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

    final response = await _dio.post("/login", data: {
      "email": email,
      "password": password,
    });

    int? statusCode = response.statusCode;
    if(statusCode != null){
      if(statusCode == 201){
        final authCredentials = AuthCredentials.fromJson(response.data);
        return right(authCredentials);
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

    final response = await _dio.post("/register", data: {
      "firstName": name,
      "lastName": name,
      "email": email,
      "password": password,
    });

    int? statusCode = response.statusCode;
    if(statusCode != null){
      if(statusCode == 201){
        final authCredentials = AuthCredentials.fromJson(response.data);
        return right(authCredentials);
      }
      else{
        final message = response.data["message"];
        return left(generateResponseMessage(message));
      }
    }
    return left([]);
  }

  Future<Either<String, AuthCredentials>> accessToken({
    required AuthCredentials authCredentials
  }) async {

    final response = await _dio.get(
      "/accesstoken",
      options: Options(headers: {"Authorization": "Bearer " + authCredentials.refreshToken})
    );

    int? statusCode = response.statusCode;
    if(statusCode != null){
      if(statusCode == 200){
        final accessToken = response.data["accessToken"];
        if(accessToken != null) return right(authCredentials.copyWith(accessToken: accessToken));
      }
    }

    final message = response.data["message"];
    if(message is String) return left(message);
    return left(""); 
  }

  Future<void> logout({required AuthCredentials authCredentials}) async {
    _dio.post(
      "/logout",
      options: Options(headers: {"Authorization": "Bearer " + authCredentials.refreshToken})
    );
  }

  Future<void> sendAccountVerificationCode({required AuthCredentials authCredentials}) async {
    _dio.get(
      "/sendAccountVerificationCode",
      options: Options(headers: {"Authorization": "Bearer " + authCredentials.accessToken})
    );
  }

  Future<Either<String, bool>> verifyAccountCode({
    required AuthCredentials authCredentials,
    required String code,
  }) async {

    final response = await _dio.get(
      "/verifyAccountCode/$code",
      options: Options(headers: {"Authorization": "Bearer " + authCredentials.accessToken})
    );

    int? statusCode = response.statusCode;
    if(statusCode != null){
      if(statusCode == 200 || statusCode == 403) return right(true);
    }

    final message = response.data["message"];
    if(message is String) return left(message);
    return left(""); 
  }
}