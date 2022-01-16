import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/helpers/response_errors.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/interceptors/access_token_interceptor.dart';

class TaskRepository{

  final AuthBloc authBloc;

  late Dio _dio;
  TaskRepository({
    required this.authBloc
  }){

    _dio = Dio(
      BaseOptions(
        baseUrl: "https://yusuf007r.dev/task-manager/task",
        connectTimeout: 5000,
        receiveTimeout: 3000,
      )
    );

    _dio.interceptors.add(
      AccessTokenInterceptor(dio: _dio)
    );
  }

  Future<List<Task>?> getTasks() async {
    try{
      final response = await _dio.get(
        "/",
        options: Options(headers: {"Authorization": "Bearer " + authBloc.state.credentials.accessToken})
      );
      return List<Task>.from(response.data.map((task) => Task.fromJson(task)));
    }
    catch (error){
      onResponseError(error: error);
    }
  }

  Future<Task?> createTask(Task task) async {

    try{
      final response = await _dio.post(
        "/",
        data: jsonEncode(task),
        options: Options(headers: {"Authorization": "Bearer " + authBloc.state.credentials.accessToken})
      );

      return Task.fromJson(response.data);
    }
    catch (error){
      onResponseError(error: error);
    }
  }
}