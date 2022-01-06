import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:task_manager/helpers/response_messages.dart';
import 'package:task_manager/models/auth_credentials.dart';

class AuthRepository {

  final _dio = Dio(
    BaseOptions(
      baseUrl: "https://yusuf007r.dev/task-manager/auth",
      validateStatus: (_) => true
    )
  );

  Future<Either<List<String>, AuthCredentials>> login({
    required String email,
    required String password,
  }) async {

    final response = await _dio.post('/login', data: {
      "email": email,
      "password": password,
    });

    int? statusCode = response.statusCode;
    if(statusCode != null){
      if(statusCode == 201){
        final authCredentials = AuthCredentials.fromJson(response.data);
        if(authCredentials.isNotEmpty) return right(authCredentials);
      }
      else{
        final message = response.data["message"];
        return left(generateResponseMessage(message));
      }
    }
    return left([]);
  }
  
  Future<Either<List<String>, AuthCredentials>> register({
    required String name,
    required String email,
    required String password,
  }) async {

    final response = await _dio.post('/register', data: {
      "firstName": name,
      "lastName": name,
      "email": email,
      "password": password,
    });

    int? statusCode = response.statusCode;
    if(statusCode != null){
      if(statusCode == 201){
        final authCredentials = AuthCredentials.fromJson(response.data);
        if(authCredentials.isNotEmpty) return right(authCredentials);
      }
      else{
        final message = response.data["message"];
        return left(generateResponseMessage(message));
      }
    }
    return left([]);
  }

  Future<bool> sendAccountVerificationCode({
    required String refreshToken
  }) async {

    final response = await _dio.get(
      '/sendAccountVerificationCode',
      options: Options(headers: {"Authorization": "Token: $refreshToken"})
    );

    int? statusCode = response.statusCode;
    if(statusCode != null){
      if(statusCode == 200){
        final authCredentials = AuthCredentials.fromJson(response.data);
        if(authCredentials.isNotEmpty) return true;
      }
    }
    return false; 
  }
}