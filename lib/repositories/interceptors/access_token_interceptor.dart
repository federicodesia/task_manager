import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/helpers/enum_helper.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/services/context_service.dart';
import 'package:task_manager/services/locator_service.dart';

class AccessTokenInterceptor extends Interceptor {

  late Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://yusuf007r.dev/task-manager/auth",
      connectTimeout: 5000,
      receiveTimeout: 3000,
    )
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try{

      try{
        final validate = options.headers["ValidateAccessToken"];
        if(!validate) return super.onRequest(options, handler);
      }
      catch(_) {}

      final token = _getAccessToken(options);
      if(token != null){
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
      if(_getAccessToken(options) != null){
        final statusCode = err.response?.statusCode;
        if(statusCode == 401 || statusCode == 403){
          final cloneRequest = await _retry(options);
          if(cloneRequest != null) return handler.resolve(cloneRequest);
        }
      }
    }
    catch(_) {}
    return super.onError(err, handler);
  }

  String? _getAccessToken(RequestOptions options){
    try{
      final token = options.headers["Authorization"].toString().split(" ").last;
      final type = JwtDecoder.decode(token)["type"];
      if(enumFromString(TokenType.values, type) == TokenType.access) return token;
    }
    catch(_) {}
    return null;
  }

  Future<Response<dynamic>?> _retry(RequestOptions options) async{
    final context = locator<ContextService>().context;
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final authCredentials = authBloc.state.credentials;

    try{
      final response = await _dio.get(
        "/access-token",
        options: Options(headers: {
          "Authorization": "Bearer " + authCredentials.refreshToken,
          "ValidateAccessToken": false
        })
      );

      final newCredentials = authCredentials.copyWith(accessToken: response.data["accessToken"]);
      authBloc.add(AuthCredentialsChanged(credentials: newCredentials));
      options.headers["Authorization"] = "Bearer " + newCredentials.accessToken;
      options.headers["ValidateAccessToken"] = false;

      try{
        final cloneRequest = await _dio.fetch(options);
        return Future.value(cloneRequest);
      }
      catch(_) {}
    }
    catch (_){}
  }
}