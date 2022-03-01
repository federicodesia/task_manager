import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:task_manager/models/auth_credentials.dart';

class AccessTokenInterceptor extends Interceptor {

  final Future<String?> Function() getRefreshToken;
  final Function(AuthCredentials) onAuthCredentialsChanged; 

  AccessTokenInterceptor({
    required this.getRefreshToken,
    required this.onAuthCredentialsChanged
  });

  late final Dio _dio = Dio(
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
      if(TokenType.values.byName(type) == TokenType.access) return token;
    }
    catch(_) {}
    return null;
  }

  Future<Response<dynamic>?> _retry(RequestOptions options) async{
    try{
      final refreshToken = await getRefreshToken();
      if(refreshToken == null) return null;

      final response = await _dio.get(
        "/access-token",
        options: Options(headers: {
          "Authorization": "Bearer " + refreshToken,
          "ValidateAccessToken": false
        })
      );

      final authCredentials = AuthCredentials(
        refreshToken: refreshToken,
        accessToken: response.data["accessToken"]
      );

      onAuthCredentialsChanged(authCredentials);
      options.headers["Authorization"] = "Bearer " + authCredentials.accessToken;
      options.headers["ValidateAccessToken"] = false;

      try{
        final cloneRequest = await _dio.fetch(options);
        return Future.value(cloneRequest);
      }
      catch(_) {}
    }
    catch (_){}
    return null;
  }
}