import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/repositories/interceptors/access_token_interceptor.dart';
import 'package:task_manager/repositories/interceptors/refresh_token_interceptor.dart';
import 'package:task_manager/services/context_service.dart';
import 'package:task_manager/services/locator_service.dart';

class BaseRepository{

  late final BaseOptions _baseOptions = BaseOptions(
    baseUrl: "https://yusuf007r.dev/task-manager/",
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  late final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  late final AuthBloc? _authBloc = _getAuthBloc;
  AuthBloc? get _getAuthBloc{
    try{
      final context = locator<ContextService>().context;
      if(context != null) return BlocProvider.of<AuthBloc>(context);
    }
    catch(_){}
    return null;
  }

  Future<String?> _getRefreshToken() async{
    try{
      if(_authBloc != null) return _authBloc?.state.credentials.refreshToken;
      return await _secureStorage.read(key: "refreshToken");
    }
    catch(_){ }
    return null;
  }

  Future<String?> _getAccessToken() async{
    try{
      if(_authBloc != null) return _authBloc?.state.credentials.accessToken;
      return await _secureStorage.read(key: "accessToken");
    }
    catch(_){}
    return null;
  }

  Future<String?> _getPasswordToken() async{
    try{
      if(_authBloc != null) return _authBloc?.state.credentials.passwordToken;
      return await _secureStorage.read(key: "passwordToken");
    }
    catch(_){}
    return null;
  }
  
  late Dio dio = Dio(_baseOptions);

  late final Dio _dioRefreshToken = Dio(_baseOptions)..interceptors.add(
    RefreshTokenInterceptor(
      onClearAuthCredentials: () {
        try{
          if(_authBloc != null) {
            _authBloc!.add(AuthCredentialsChanged(credentials: AuthCredentials.empty));
          } else{
            _secureStorage.deleteAll();
          }
        }
        catch(_){}
      }
    )
  );
  Future<Dio> dioRefreshToken() async{
    final _refreshToken = await _getRefreshToken() ?? "";
    return _dioRefreshToken..options.headers = {
      "Authorization": "Bearer " + _refreshToken
    };
  }

  late final Dio _dioAccessToken = Dio(_baseOptions)..interceptors.add(
    AccessTokenInterceptor(
      getRefreshToken: () => _getRefreshToken(),
      onUpdateAccessToken: (accessToken) {
        try{
          final _authBlocState = _authBloc?.state;
          if(_authBloc != null && _authBlocState != null) {
            _authBloc!.add(AuthCredentialsChanged(
              credentials: _authBlocState.credentials.copyWith(accessToken: accessToken)
            ));
          } else{
            _secureStorage.write(key: "accessToken", value: accessToken);
          }
        }
        catch(_){}
      }
    )
  );
  Future<Dio> dioAccessToken() async{
    final _accessToken = await _getAccessToken() ?? "";
    return _dioAccessToken..options.headers = {
      "Authorization": "Bearer " + _accessToken
    };
  }

  late final Dio _dioPasswordToken = Dio(_baseOptions);
  Future<Dio> dioPasswordToken() async{
    final _passwordToken = await _getPasswordToken() ?? "";
    return _dioPasswordToken..options.headers = {
      "Authorization": "Bearer " + _passwordToken
    };
  }
}