import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/helpers/string_helper.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/repositories/interceptors/access_token_interceptor.dart';
import 'package:task_manager/repositories/interceptors/refresh_token_interceptor.dart';
import 'package:task_manager/services/context_service.dart';
import 'package:task_manager/services/locator_service.dart';

class BaseRepository{

  BaseRepository(){
    _init();
  }
  
  late BaseOptions _baseOptions;
  late AuthBloc? _authBloc;

  late final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  void _init() async{

    String? deviceName;
    try{
      if(Platform.isAndroid){
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        final androidDeviceName = [ (androidInfo.brand ?? "").capitalize, androidInfo.model ];
        androidDeviceName.removeWhere((s) => s == null || s.isEmpty);
        deviceName = androidDeviceName.join(" ");
      }
    }
    catch(_){}

    _baseOptions = BaseOptions(
      baseUrl: "https://yusuf007r.dev/task-manager/",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: { "device-name": deviceName }
    );

    try{
      final context = locator<ContextService>().context;
      if(context != null) _authBloc = context.read<AuthBloc>();
    }
    catch(_){}
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
    return _dioRefreshToken..options.headers.addAll({
      "Authorization": "Bearer " + _refreshToken
    });
  }

  late final Dio _dioAccessToken = Dio(_baseOptions)..interceptors.add(
    AccessTokenInterceptor(
      getDioRefreshToken: dioRefreshToken,
      getDioAccessToken: dioAccessToken,
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
    return _dioAccessToken..options.headers.addAll(
      {"Authorization": "Bearer " + _accessToken}
    );
  }

  late final Dio _dioPasswordToken = Dio(_baseOptions);
  Future<Dio> dioPasswordToken() async{
    final _passwordToken = await _getPasswordToken() ?? "";
    return _dioPasswordToken..options.headers.addAll(
      {"Authorization": "Bearer " + _passwordToken}
    );
  }
}