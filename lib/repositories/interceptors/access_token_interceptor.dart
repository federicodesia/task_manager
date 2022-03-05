import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AccessTokenInterceptor extends Interceptor {

  final Future<Dio> Function() getDioRefreshToken;
  final Future<bool> Function(String) onUpdateAccessToken; 
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
      final dioRefreshToken = await getDioRefreshToken();
      final response = await dioRefreshToken.get("/auth/access-token");
      final accessToken = response.data["accessToken"] as String? ?? "";

      final updated = await onUpdateAccessToken(accessToken);
      if(updated){
        try{
          final dioAccessToken = await getDioAccessToken();

          options.headers.addAll(dioAccessToken.options.headers);
          options.headers.addAll({ "IsRetryRequest" : true });

          return await dioAccessToken.fetch(options);
        }
        catch(_) {}
      }
    }
    catch (_){}
    return null;
  }
}