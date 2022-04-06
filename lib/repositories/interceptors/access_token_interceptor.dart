import 'dart:async';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/repositories/base_repository.dart';
import 'package:task_manager/repositories/interceptors/unauthorized_interceptor.dart';

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
      final token = (options.headers["Authorization"] as String).split(" ").last;
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
    try{
      final statusCode = err.response?.statusCode;
      if(statusCode == 401 || statusCode == 403){

        final cloneRequest = await _retry(err.requestOptions);
        if(cloneRequest != null) return handler.resolve(cloneRequest);
      }
    }
    catch(_) {}
    return super.onError(err, handler);
  }

  Future<Response<dynamic>?> _retry(RequestOptions options) async{
    try{
      final authRepository = AuthRepository(base: baseRepository);
      final accessToken = await authRepository.accessToken();

      if(accessToken != null){
        final currentCredentials = await authBloc.secureStorageRepository.read.authCredentials;
        authBloc.add(AuthCredentialsChanged(currentCredentials.copyWith(accessToken: accessToken)));

        final dioAccessToken = baseRepository.dio..interceptors.add(UnauthorizedInterceptor(authBloc: authBloc));
        options.headers.addAll({ "Authorization": "Bearer " + accessToken });

        return await dioAccessToken.fetch(options);
      }
    }
    catch (_){}
    return null;
  }
}