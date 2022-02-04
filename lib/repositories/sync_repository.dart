import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/helpers/response_errors.dart';
import 'package:task_manager/models/either.dart';
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
  

  Future<Either<String, List<T>>?> push<T>({
    required String queryPath,
    required List<T> items
  }) async {
    try{
      if(items.isEmpty) return null;
      
      final response = await _dio.post(
        "/$queryPath/",
        options: Options(headers: {"Authorization": "Bearer " + authBloc.state.credentials.accessToken}),
        data: jsonEncode(items)
      );

      return Right(SyncObject.listFromJson<T>(response.data) ?? []);
    }
    catch (error){
      if(error is DioError){
        final message = error.response?.data["message"];
        if(message is String && message.startsWith("duplicated id")){
          return Left(message.split(":").last);
        }
      }
      onResponseError(error: error);
    }
  }
}