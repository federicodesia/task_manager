import 'package:dio/dio.dart';
import 'package:task_manager/models/auth_credentials.dart';

class RefreshTokenInterceptor extends Interceptor {

  final Function(AuthCredentials) onAuthCredentialsChanged; 
  RefreshTokenInterceptor({required this.onAuthCredentialsChanged});

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    try{
      final statusCode = err.response?.statusCode;
      if(statusCode == 401 || statusCode == 403){
        onAuthCredentialsChanged(AuthCredentials.empty);
      }
    }
    catch(_) {}
    return super.onError(err, handler);
  }
}