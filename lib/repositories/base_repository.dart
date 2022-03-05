import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/helpers/string_helper.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/repositories/interceptors/access_token_interceptor.dart';
import 'package:task_manager/repositories/interceptors/refresh_token_interceptor.dart';
import 'package:task_manager/repositories/secure_storage_repository.dart';
import 'package:task_manager/services/context_service.dart';
import 'package:task_manager/services/locator_service.dart';

class BaseRepository{

  BaseRepository(){
    _init();
  }
  
  late BaseOptions _baseOptions;
  late AuthBloc? _authBloc;
  late Dio dio;

  late final SecureStorageRepository _secureStorageRepository = SecureStorageRepository();
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
    dio = Dio(_baseOptions);

    try{
      final context = locator<ContextService>().context;
      if(context != null) _authBloc = context.read<AuthBloc>();
    }
    catch(_){}
  }

  late final Dio _dioRefreshToken = Dio(_baseOptions)..interceptors.add(
    RefreshTokenInterceptor(
      onClearAuthCredentials: () {
        try{
          if(_authBloc != null) {
            _authBloc!.add(AuthCredentialsChanged(credentials: AuthCredentials.empty));
          } else{
            _secureStorageRepository.delete.all();
          }
        }
        catch(_){}
      }
    )
  );
  Future<Dio> dioRefreshToken() async{
    try{
      String _refreshToken = _authBloc != null
        ? _authBloc!.state.credentials.refreshToken
        :  await _secureStorageRepository.read.refreshToken as String;

      return _dioRefreshToken..options.headers.addAll(
        {"Authorization": "Bearer " + _refreshToken}
      );
    }
    catch(_){}
    return _dioRefreshToken;
  }

  late final Dio _dioAccessToken = Dio(_baseOptions)..interceptors.add(
    AccessTokenInterceptor(
      getDioRefreshToken: dioRefreshToken,
      getDioAccessToken: dioAccessToken,
      onUpdateAccessToken: (accessToken) async{
        try{
          final state = _authBloc?.state;
          if(_authBloc != null && state != null) {
            _authBloc!.add(AuthCredentialsChanged(
              credentials: state.credentials.copyWith(accessToken: accessToken)
            ));
            await _authBloc!.stream.first.then((_){
              return true;
            }).timeout(const Duration(seconds: 1));
          }
          await _secureStorageRepository.write.accessToken(accessToken);
          return true;
        }
        catch(_){}
        return false;
      }
    )
  );
  Future<Dio> dioAccessToken() async{
    try{
      String _accessToken = _authBloc != null
        ? _authBloc!.state.credentials.accessToken
        :  await _secureStorageRepository.read.accessToken as String;

      return _dioAccessToken..options.headers.addAll(
        {"Authorization": "Bearer " + _accessToken}
      );
    }
    catch(_){}
    return _dioAccessToken;
  }

  late final Dio _dioPasswordToken = Dio(_baseOptions);
  Future<Dio> dioPasswordToken() async{
    try{
      String _passwordToken = _authBloc != null
        ? _authBloc!.state.credentials.passwordToken
        :  await _secureStorageRepository.read.passwordToken as String;

      return _dioPasswordToken..options.headers.addAll(
        {"Authorization": "Bearer " + _passwordToken}
      );
    }
    catch(_){}
    return _dioPasswordToken;
  }
}