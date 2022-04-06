import 'dart:async';
import 'package:dio/dio.dart';
import 'package:task_manager/helpers/response_errors.dart';
import 'package:task_manager/helpers/response_messages.dart';
import 'package:task_manager/models/active_session.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/either.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/repositories/base_repository.dart';

class AuthRepository{

  final BaseRepository base;
  AuthRepository({required this.base});

  Future<Either<ResponseMessage, AuthCredentials>?> login({
    required String email,
    required String password,
    List<String>? ignoreKeys
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
      final responseMessage = await ResponseError.validate(error, ignoreKeys);
      if(responseMessage != null) return Left(responseMessage);
      return null;
    }
  }
  
  Future<Either<ResponseMessage, AuthCredentials>?> register({
    required String name,
    required String email,
    required String password,
    List<String>? ignoreKeys
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
      final responseMessage = await ResponseError.validate(error, ignoreKeys);
      if(responseMessage != null) return Left(responseMessage);
      return null;
    }
  }

  Future<String?> accessToken() async {
    try{
      final dio = await base.dioRefreshToken;
      final response = await dio.get("/auth/access-token");
      return response.data["accessToken"] as String;
    }
    catch (error){
      return null;
    }
  }

  Future<void> logout() async {
    try{
      final dio = await base.dioRefreshToken;
      await dio.post("/auth/logout");
    }
    catch (error){
      await ResponseError.validate(error, null);
    }
  }

  Future<bool> logoutAll() async {
    try{
      final dio = await base.dioRefreshToken;
      await dio.post("/auth/logout/all");
      return true;
    }
    catch (error){
      await ResponseError.validate(error, null);
      return false;
    }
  }

  Future<bool> logoutBySessionId({
    required int sessionId
  }) async {
    try{
      final dio = await base.dioAccessToken;
      await dio.post("/auth/logout-by-session-id/$sessionId");
      return true;
    }
    catch (error){
      await ResponseError.validate(error, null);
      return false;
    }
  }

  Future<Either<ResponseMessage, void>?> sendAccountVerificationCode({
    bool Function(String)? ignoreFunction
  }) async {
    try{
      final dio = await base.dioAccessToken;
      await dio.post("/auth/send-account-verification-code");
      return const Right(null);
    }
    catch (error){
      final responseMessage = await ResponseError.validate(error, null, ignoreFunction: ignoreFunction);
      if(responseMessage != null) return Left(responseMessage);
      return null;
    }
  }

  Future<Either<ResponseMessage, String>?> verifyAccountCode({
    required String code,
    List<String>? ignoreKeys
  }) async {

    try{
      final dio = await base.dioAccessToken;
      final response = await dio.post(
        "/auth/verify-account-code",
        data: {
          "code": code
        },
      );
      return Right(response.data["accessToken"] as String);
    }
    catch(error){

      if(error is DioError){
        try{
          final responseMessages = ResponseMessage(
            statusCode: error.response?.statusCode,
            responseMessage: error.response?.data["message"]
          );

          if(responseMessages.contains("user already verified")){
            final newAccessToken = await accessToken();
            if(newAccessToken != null) return Right(newAccessToken);
          }
        }
        catch(_){}
      }

      final responseMessage = await ResponseError.validate(error, ignoreKeys);
      if(responseMessage != null) return Left(responseMessage);
      return null;
    }
  }

  Future<Either<ResponseMessage, void>?> sendPasswordResetCode({
    required String email,
    List<String>? ignoreKeys,
    bool Function(String)? ignoreFunction
  }) async {

    try{
      await base.dio.post(
        "/auth/send-password-reset-code",
        data: {
          "email": email
        }
      );
      return const Right(null);
    }
    catch (error){
      final responseMessage = await ResponseError.validate(error, ignoreKeys, ignoreFunction: ignoreFunction);
      if(responseMessage != null) return Left(responseMessage);
      return null;
    }
  }

   Future<Either<ResponseMessage, AuthCredentials>?> verifyPasswordCode({
    required String email,
    required String code,
    List<String>? ignoreKeys
  }) async {

    try{
      final response = await base.dio.post(
        "/auth/verify-password-code",
        data: {
          "email": email,
          "code": code
        },
      );
      return Right(AuthCredentials.empty.copyWith(
        passwordToken: response.data["accessToken"]
      ));
    }
    catch (error){
      final responseMessage = await ResponseError.validate(error, ignoreKeys);
      if(responseMessage != null) return Left(responseMessage);
      return null;
    }
  }

  Future<Either<ResponseMessage, void>?> changeForgotPassword({
    required String password,
    List<String>? ignoreKeys
  }) async {

    try{
      final dio = await base.dioPasswordToken;
      await dio.post(
        "/auth/change-forgot-password",
        data: {
          "password": password
        }
      );
      return const Right(null);
    }
    catch (error){
      final responseMessage = await ResponseError.validate(error, ignoreKeys);
      if(responseMessage != null) return Left(responseMessage);
      return null;
    }
  }

  Future<Either<ResponseMessage, void>?> changePassword({
    required String currentPassword,
    required String newPassword,
    List<String>? ignoreKeys
  }) async {

    try{
      final dio = await base.dioAccessToken;
      await dio.post(
        "/auth/change-password",
        data: {
          "password": currentPassword,
          "newPassword": newPassword
        }
      );
      return const Right(null);
    }
    catch (error){
      final responseMessage = await ResponseError.validate(error, ignoreKeys);
      if(responseMessage != null) return Left(responseMessage);
      return null;
    }
  }

  Future<Either<ResponseMessage, void>?> sendChangeEmailCode({
    required String email,
    List<String>? ignoreKeys,
    bool Function(String)? ignoreFunction
  }) async {

    try{
      final dio = await base.dioAccessToken;
      await dio.post(
        "/auth/send-change-email-code",
        data: {
          "email": email
        }
      );
      return const Right(null);
    }
    catch (error){
      final responseMessage = await ResponseError.validate(error, ignoreKeys, ignoreFunction: ignoreFunction);
      if(responseMessage != null) return Left(responseMessage);
      return null;
    }
  }

  Future<Either<ResponseMessage, User>?> verifyChangeEmailCode({
    required String code,
    List<String>? ignoreKeys
  }) async {

    try{
      final dio = await base.dioAccessToken;
      final response = await dio.post(
        "/auth/verify-change-email-code",
        data: {
          "code": code
        }
      );
      return Right(User.fromJson(response.data));
    }
    catch (error){
      final responseMessage = await ResponseError.validate(error, ignoreKeys);
      if(responseMessage != null) return Left(responseMessage);
      return null;
    }
  }

  Future<bool> setFirebaseMessagingToken(String token) async {
    try{
      final dio = await base.dioRefreshToken;
      await dio.post("/auth/set-fcm-token/$token");
      return true;
    }
    catch (error){
      await ResponseError.validate(error, null);
      return false;
    }
  }

  Future<List<ActiveSession>?> getActiveSessions() async {
    try{
      final dio = await base.dioAccessToken;
      final response = await dio.get("/auth/get-active-sessions");
      return List<ActiveSession>.from(response.data
        .map((activeSession) => ActiveSession.fromJson(activeSession))
      );
    }
    catch (error){
      await ResponseError.validate(error, null);
    }
    return null;
  }
}