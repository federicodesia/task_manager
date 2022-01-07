import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/user.dart';

class UserRepository {

  final _dio = Dio(
    BaseOptions(
      baseUrl: "https://yusuf007r.dev/task-manager/user",
      validateStatus: (_) => true
    )
  );
  
  Future<Either<List<String>, User>> getUser({
    required AuthCredentials authCredentials,
  }) async {

    final response = await _dio.get(
      "/",
      options: Options(headers: {"Authorization": "Bearer " + authCredentials.accessToken})
    );

    int? statusCode = response.statusCode;
    if(statusCode != null){
      if(statusCode == 200){
        final user = User.fromJson(response.data);
        return right(user);
      }
      else{
        final message = response.data["message"];
        return left(message is List<dynamic> ? message.map((m) => m.toString()).toList() : [message]);
      }
    }
    return left([]);
  }
}