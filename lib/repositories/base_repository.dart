import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/helpers/string_helper.dart';
import 'package:task_manager/repositories/interceptors/access_token_interceptor.dart';
import 'package:task_manager/repositories/interceptors/unauthorized_interceptor.dart';

class BaseRepository{
  final AuthBloc authBloc;
  BaseRepository({required this.authBloc}){
    _init();
  }

  late final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  
  late BaseOptions _baseOptions;

  late final Dio dio;
  late final Dio _dioAccessToken;
  late final Dio _dioRefreshToken;
  late final Dio _dioPasswordToken;

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

    _dioRefreshToken = Dio(_baseOptions)..interceptors.add(
      UnauthorizedInterceptor(authBloc: authBloc)
    );

    _dioAccessToken = Dio(_baseOptions)..interceptors.add(
      AccessTokenInterceptor(
        authBloc: authBloc,
        baseRepository: this
      )
    );

    _dioPasswordToken = Dio(_baseOptions);
  }

  Future<Dio> get dioRefreshToken async{
    try{
      final refreshToken = await authBloc.secureStorageRepository.read.refreshToken;
      return _dioRefreshToken..options.headers.addAll(
        {"Authorization": "Bearer " + refreshToken}
      );
    }
    catch(_){}
    return _dioRefreshToken;
  }

  Future<Dio> get dioAccessToken async{
    try{
      final accessToken = await authBloc.secureStorageRepository.read.accessToken;
      return _dioAccessToken..options.headers.addAll(
        {"Authorization": "Bearer " + accessToken}
      );
    }
    catch(_){}
    return _dioAccessToken;
  }

  Future<Dio> get dioPasswordToken async{
    try{
      final passwordToken = await authBloc.secureStorageRepository.read.passwordToken;
      return _dioPasswordToken..options.headers.addAll(
        {"Authorization": "Bearer " + passwordToken}
      );
    }
    catch(_){}
    return _dioPasswordToken;
  }
}