import 'package:dio/dio.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/models/auth_credentials.dart';

class UnauthorizedInterceptor extends Interceptor {

  final AuthBloc authBloc;
  UnauthorizedInterceptor({required this.authBloc});

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    try{
      final statusCode = err.response?.statusCode;
      if(statusCode == 401 || statusCode == 403){

        if(authBloc.state.status == AuthStatus.authenticated){
          authBloc.add(AuthCredentialsChanged(AuthCredentials.empty));
        }
      }
    }
    catch(_) {}
    return super.onError(err, handler);
  }
}