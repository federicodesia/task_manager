import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/helpers/enum_helper.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/services/context_service.dart';
import 'package:task_manager/services/locator_service.dart';

class AccessTokenInterceptor extends Interceptor {

  final Dio dio;
  final AuthRepository authRepository;

  AccessTokenInterceptor({
    required this.dio,
    required this.authRepository
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    try{
      final token = options.headers["Authorization"].toString().split(" ").last;
      final type = JwtDecoder.decode(token)["type"];
      if(enumFromString(TokenType.values, type) == TokenType.access){

        final remainingTime = JwtDecoder.getRemainingTime(token);
        final timeout = options.sendTimeout + options.connectTimeout + options.receiveTimeout;
        if(remainingTime.inMilliseconds < timeout){

          final context = locator<ContextService>().context;
          final authBloc = BlocProvider.of<AuthBloc>(context);

          final response = await authRepository.accessToken(
            authCredentials: authBloc.state.credentials
          );

          response.fold(
            (message) {},
            (credentials) async{
              authBloc.add(AuthCredentialsChanged(credentials: credentials));
              options.headers["Authorization"] = "Bearer " + credentials.accessToken;

              try{
                final cloneRequest = await dio.request(
                  options.path,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                  ),
                  data: options.data,
                  queryParameters: options.queryParameters
                );

                return handler.resolve(cloneRequest);
              }
              catch(_) {}
            }, 
          );
        }
      }
    }
    catch(_) {}

    return super.onRequest(options, handler);
  }

  /*@override
  Future onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }*/
}