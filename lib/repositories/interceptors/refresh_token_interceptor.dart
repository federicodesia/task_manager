import 'package:dio/dio.dart';

class RefreshTokenInterceptor extends Interceptor {

  final void Function() onClearAuthCredentials; 
  RefreshTokenInterceptor({required this.onClearAuthCredentials});

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    try{
      final statusCode = err.response?.statusCode;
      if(statusCode == 401 || statusCode == 403){
        onClearAuthCredentials();
      }
    }
    catch(_) {}
    return super.onError(err, handler);
  }
}