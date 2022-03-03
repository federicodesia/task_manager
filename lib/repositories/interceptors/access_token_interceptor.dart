import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AccessTokenInterceptor extends Interceptor {

  final Future<Dio> Function() getDioRefreshToken;
  final Function(String) onUpdateAccessToken; 
  final Future<Dio> Function() getDioAccessToken;

  AccessTokenInterceptor({
    required this.getDioRefreshToken,
    required this.onUpdateAccessToken,
    required this.getDioAccessToken
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try{

      try{
        final isRetry = options.headers["IsRetryRequest"] as bool?;
        if(isRetry != null && isRetry) return super.onRequest(options, handler);
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

          final isRetry = options.headers["IsRetryRequest"] as bool?;
          if(isRetry == null || isRetry){
            final cloneRequest = await _retry(options);
            if(cloneRequest != null) return handler.resolve(cloneRequest);
          }
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
      final dioRefreshToken = await getDioRefreshToken();
      final response = await dioRefreshToken.get("/auth/access-token");
      final accessToken = response.data["accessToken"] as String? ?? "";
      onUpdateAccessToken(accessToken);

      try{
        final dioAccessToken = await getDioAccessToken();

        options.headers.addAll(dioAccessToken.options.headers);
        options.headers.addAll({ "IsRetryRequest" : true });

        final cloneRequest = await dioAccessToken.fetch(options);
        return Future.value(cloneRequest);
      }
      catch(_) {}
    }
    catch (_){}
    return null;
  }
}