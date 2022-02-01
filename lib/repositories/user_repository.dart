import 'dart:async';

import 'package:dio/dio.dart';
import 'package:task_manager/helpers/response_errors.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/either.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/repositories/interceptors/access_token_interceptor.dart';

class UserRepository {

  late Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://yusuf007r.dev/task-manager/user",
      connectTimeout: 5000,
      receiveTimeout: 3000,
    )
  )..interceptors.add(AccessTokenInterceptor());
  
  Future<Either<String, User>?> getUser({
    required AuthCredentials authCredentials,
  }) async {

    try{
      final response = await _dio.get(
        "/",
        options: Options(headers: {"Authorization": "Bearer " + authCredentials.accessToken})
      );
      return Right(User.fromJson(response.data));
    }
    catch (error){
      final errorMessages = await onResponseError(error: error);
      if(errorMessages != null) return Left(errorMessages.first);
      return null;
    }
  }
}