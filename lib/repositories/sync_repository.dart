import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/helpers/response_errors.dart';
import 'package:task_manager/models/sync_object.dart';
import 'package:task_manager/repositories/interceptors/access_token_interceptor.dart';

class SyncRepository{

  final AuthBloc authBloc;
  SyncRepository({required this.authBloc});

  late Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://yusuf007r.dev/task-manager/sync",
      connectTimeout: 5000,
      receiveTimeout: 3000,
    )
  )..interceptors.add(AccessTokenInterceptor());
  

  Future<List<T>?> push<T>({
    required String queryPath,
    required List<T> items
  }) async {
    try{
      final response = await _dio.post(
        "/$queryPath/",
        options: Options(headers: {"Authorization": "Bearer " + authBloc.state.credentials.accessToken}),
        data: jsonEncode(items)
      );

      return SyncObject.listFromJson<T>(response.data);
    }
    catch (error){
      // TODO: Remove print
      if(error is DioError) print(error.response?.data["message"]);
      else onResponseError(error: error);
    }
  }
}