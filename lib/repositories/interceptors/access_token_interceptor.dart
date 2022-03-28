import 'dart:async';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/repositories/base_repository.dart';

class AccessTokenInterceptor extends Interceptor {

  final AuthBloc authBloc;
  final BaseRepository baseRepository;

  AccessTokenInterceptor({
    required this.authBloc,
    required this.baseRepository
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try{

      try{
        final isRetry = options.headers["IsRetryRequest"] as bool?;
        if(isRetry != null && isRetry) return super.onRequest(options, handler);
      }
      catch(_) {}

      final token = options.headers["Authorization"].toString().split(" ").last;
      if(token.isNotEmpty){
        final remainingTime = JwtDecoder.getRemainingTime(token);
        final timeout = options.sendTimeout + options.connectTimeout + options.receiveTimeout;
        if(remainingTime.inMilliseconds < timeout){

          final cloneRequest = await _retry(options);
          if(cloneRequest != null) return handler.resolve(cloneRequest);
        }
      }
    }
    catch(_) {}
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;

    try{
      final statusCode = err.response?.statusCode;
      if(statusCode == 401 || statusCode == 403){

        final isRetry = options.headers["IsRetryRequest"] as bool?;
        if(isRetry == null || !isRetry){
          final cloneRequest = await _retry(options);
          if(cloneRequest != null) return handler.resolve(cloneRequest);
        }
      }
    }
    catch(_) {}
    return super.onError(err, handler);
  }

  Future<Response<dynamic>?> _retry(RequestOptions options) async{
    try{
      final authRepository = AuthRepository(base: baseRepository);
      final currentCredentials = await authBloc.secureStorageRepository.read.authCredentials;

      final response = await authRepository.accessToken(
        authCredentials: currentCredentials,
        ignoreAllErrors: true
      );

      if(response != null){
        response.when(
          left: (responseMessage) {},
          right: (credentials) async{

            authBloc.add(AuthCredentialsChanged(credentials));
            
            return await authBloc.stream.first
              .timeout(const Duration(seconds: 2), onTimeout: (){
                throw TimeoutException("AuthBloc timeout");
              })
              .then((value) async{

                try{
                  final dioAccessToken = await baseRepository.dioAccessToken;

                  options.headers.addAll(dioAccessToken.options.headers);
                  options.headers.addAll({ "IsRetryRequest" : true });

                  return await dioAccessToken.fetch(options);
                }
                catch(_) {}
              })
              .onError((error, stackTrace) => null);
          }
        );
      }
    }
    catch (_){}
    return null;
  }
}