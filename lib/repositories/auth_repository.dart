import 'dart:async';
import 'package:task_manager/helpers/response_errors.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/either.dart';
import 'package:task_manager/repositories/base_repository.dart';

class AuthRepository{

  final BaseRepository base;
  AuthRepository({required this.base});

  Future<Either<List<String>, AuthCredentials>?> login({
    required String email,
    required String password,
    List<String>? messageKeys
  }) async {

    try{
      final response = await base.dio.post(
        "/auth/login",
        data: {
          "email": email,
          "password": password,
        }
      );
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
      final response = await base.dio.post(
        "/auth/register",
        data: {
          "name": name,
          "email": email,
          "password": password,
        }
      );
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
      final dio = await base.dioRefreshToken();
      final response = await dio.get("/auth/access-token");
      return Right(authCredentials.copyWith(accessToken: response.data["accessToken"]));
    }
    catch (error){
      final errorMessages = await onResponseError(error: error);
      return Left(errorMessages != null && errorMessages.isNotEmpty ? errorMessages.first : "");
    }
  }

  Future<void> logout() async {
    try{
      final dio = await base.dioRefreshToken();
      await dio.post("/auth/logout");
    }
    catch (error){
      await onResponseError(error: error);
    }
  }

  Future<void> sendAccountVerificationCode() async {
    try{
      final dio = await base.dioAccessToken();
      await dio.post("/auth/send-account-verification-code");
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
      final dio = await base.dioAccessToken();
      final response = await dio.post(
        "/auth/verify-account-code",
        data: {
          "code": code
        },
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
      await base.dio.post(
        "/auth/send-password-reset-code",
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
      final response = await base.dio.post(
        "/auth/verify-password-code",
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
    required String password
  }) async {

    try{
      final dio = await base.dioAccessToken();
      await dio.post(
        "/auth/change-forgot-password",
        data: {
          "password": password
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

  Future<void> setFirebaseMessagingToken({
    required String token
  }) async {
    try{
      final dio = await base.dioRefreshToken();
      await dio.post("/auth/set-fcm-token/$token");
    }
    catch (error){
      await onResponseError(error: error);
    }
  }
}