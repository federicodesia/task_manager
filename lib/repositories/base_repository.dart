import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/repositories/interceptors/access_token_interceptor.dart';
import 'package:task_manager/services/context_service.dart';
import 'package:task_manager/services/locator_service.dart';

class BaseRepository{

  late BaseOptions baseOptions = BaseOptions(
    baseUrl: "https://yusuf007r.dev/task-manager/",
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  
  late BuildContext context = locator<ContextService>().context;
  late AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
  
  late Dio dio = Dio(baseOptions);

  late Dio _dioRefreshToken = Dio(baseOptions);
  Dio get dioRefreshToken => _dioRefreshToken..options.headers = {
    "Authorization": "Bearer " + authBloc.state.credentials.refreshToken
  };

  late Dio _dioAccessToken = Dio(baseOptions)..interceptors.add(AccessTokenInterceptor());
  Dio get dioAccessToken => _dioAccessToken..options.headers = {
    "Authorization": "Bearer " + authBloc.state.credentials.accessToken
  };
}