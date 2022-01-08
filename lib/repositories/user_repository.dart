import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:task_manager/helpers/response_messages.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/user.dart';

class UserRepository {

  final _dio = Dio(
    BaseOptions(
      baseUrl: "https://yusuf007r.dev/task-manager/user",
      validateStatus: (_) => true,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    )
  );
  
  Future<Either<List<String>, User>> getUser({
    required AuthCredentials authCredentials,
  }) async {

    try{
      final response = await _dio.get(
        "/",
        options: Options(headers: {"Authorization": "Bearer " + authCredentials.accessToken})
      );

      if(response.statusCode == 200){
        final user = User.fromJson(response.data);
        return right(user);
      }
      final message = response.data["message"];
      return left(generateResponseMessage(message));
    }
    catch(_){
      return left([]);
    }
  }
}