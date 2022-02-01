import 'dart:async';
import 'package:dio/dio.dart';
import 'package:task_manager/helpers/response_errors.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/either.dart';
import 'package:task_manager/repositories/interceptors/access_token_interceptor.dart';

class AuthRepository {

  late Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://yusuf007r.dev/task-manager/auth",
      connectTimeout: 5000,
      receiveTimeout: 3000,
    )
  )..interceptors.add(AccessTokenInterceptor());

  Future<Either<List<String>, AuthCredentials>?> login({
    required String email,
    required String password,
    List<String>? messageKeys
  }) async {

    try{
      final response = await _dio.post("/login", data: {
        "email": email,
        "password": password,
      });
      return Right(AuthCredentials.fromJson(response.data));
    }
    catch (error){
      final errorMessages = await onResponseError(error: error, messageKeys: messageKeys);
      if(errorMessages != null) return Left(errorMessages);
      return null;
    }
  }
  
  Future<Either<List<String>, AuthCredentials>?> register({
    required String name,
    required String email,
    required String password,
    List<String>? messageKeys
  }) async {

    try{
      final response = await _dio.post("/register", data: {
        "name": name,
        "email": email,
        "password": password,
      });
      return Right(AuthCredentials.fromJson(response.data));
    }
    catch (error){
      final errorMessages = await onResponseError(error: error, messageKeys: messageKeys);
      if(errorMessages != null) return Left(errorMessages);
      return null;
    }
  }

  Future<Either<String, AuthCredentials>> accessToken({
    required AuthCredentials authCredentials
  }) async {

    try{
      final response = await _dio.get(
        "/access-token",
        options: Options(headers: {"Authorization": "Bearer " + authCredentials.refreshToken})
      );
      return Right(authCredentials.copyWith(accessToken: response.data["accessToken"]));
    }
    catch (error){
      final errorMessages = await onResponseError(error: error);
      return Left(errorMessages != null && errorMessages.isNotEmpty ? errorMessages.first : "");
    }
  }

  Future<void> logout({
    required AuthCredentials authCredentials
  }) async {
    
    try{
      await _dio.post(
        "/logout",
        options: Options(headers: {"Authorization": "Bearer " + authCredentials.refreshToken})
      );
    }
    catch (error){
      await onResponseError(error: error);
    }
  }

  Future<void> sendAccountVerificationCode({
    required AuthCredentials authCredentials
  }) async {

    try{
      await _dio.post(
        "/send-account-verification-code",
        options: Options(headers: {"Authorization": "Bearer " + authCredentials.accessToken})
      );
    }
    catch (error){
      await onResponseError(error: error);
    }
  }

  Future<Either<String, AuthCredentials>?> verifyAccountCode({
    required AuthCredentials authCredentials,
    required String code,
  }) async {

    try{
      final response = await _dio.post(
        "/verify-account-code",
        data: {
          "code": code
        },
        options: Options(headers: {"Authorization": "Bearer " + authCredentials.accessToken})
      );
      return Right(authCredentials.copyWith(accessToken: response.data["accessToken"]));
    }
    catch(error){
      final errorMessages = await onResponseError(error: error);
      if(errorMessages != null) return Left(errorMessages.first);
      return null;
    }
  }

  Future<Either<String, void>?> sendPasswordResetCode({
    required String email
  }) async {

    try{
      await _dio.post(
        "/send-password-reset-code",
        data: {
          "email": email
        }
      );
      return Right(() {});
    }
    catch (error){
      final errorMessages = await onResponseError(error: error);
      if(errorMessages != null) return Left(errorMessages.first);
      return null;
    }
  }

   Future<Either<String, AuthCredentials>?> verifyPasswordCode({
    required String email,
    required String code
  }) async {

    try{
      final response = await _dio.post(
        "/verify-password-code",
        data: {
          "email": email,
          "code": code
        },
      );
      return Right(AuthCredentials(
        refreshToken: "",
        accessToken: response.data["accessToken"]
      ));
    }
    catch (error){
      final errorMessages = await onResponseError(error: error);
      if(errorMessages != null) return Left(errorMessages.first);
      return null;
    }
  }

  Future<Either<String, void>?> changeForgotPassword({
    required AuthCredentials credentials,
    required String password
  }) async {

    try{
      await _dio.post(
        "/change-forgot-password",
        data: {
          "password": password
        },
        options: Options(headers: {"Authorization": "Bearer " + credentials.accessToken})
      );
      return Right(() {});
    }
    catch (error){
      final errorMessages = await onResponseError(error: error);
      if(errorMessages != null) return Left(errorMessages.first);
      return null;
    }
  }
}