import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AccessTokenInterceptor extends Interceptor {

  final Future<String?> Function() getRefreshToken;
  final Function(String) onUpdateAccessToken; 

  AccessTokenInterceptor({
    required this.getRefreshToken,
    required this.onUpdateAccessToken
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
      if(_getAccessToken(options).isNotEmpty){
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

  String _getAccessToken(RequestOptions options){
    return options.headers["Authorization"].toString().split(" ").last;
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

      final accessToken = response.data["accessToken"];
      onUpdateAccessToken(accessToken);

      options.headers["Authorization"] = "Bearer " + accessToken;
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