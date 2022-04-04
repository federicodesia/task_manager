import 'dart:async';

import 'package:task_manager/helpers/response_errors.dart';
import 'package:task_manager/helpers/response_messages.dart';
import 'package:task_manager/models/either.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/repositories/base_repository.dart';

class UserRepository {

  final BaseRepository base;
  UserRepository({required this.base});
  
  Future<User?> getUser() async {

    try{
      final dio = await base.dioAccessToken;
      final response = await dio.get("/user/");
      return User.fromJson(response.data);
    }
    catch (error){
      await ResponseError.validate(error, null);
      return null;
    }
  }

  Future<Either<ResponseMessage, User>?> updateUser({
    String? name,
    String? imageUrl
  }) async {

    try{
      final dio = await base.dioAccessToken;
      final response = await dio.patch(
        "/user/",
        data: {
          if(name != null) "name": name,
          if(imageUrl != null) "imageUrl": imageUrl
        }
      );
      return Right(User.fromJson(response.data));
    }
    catch (error){
      final responseMessage = await ResponseError.validate(error, null);
      if(responseMessage != null) return Left(responseMessage);
      return null;
    }
  }
}