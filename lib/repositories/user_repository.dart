import 'dart:async';

import 'package:task_manager/helpers/response_errors.dart';
import 'package:task_manager/models/either.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/repositories/base_repository.dart';

class UserRepository {

  final BaseRepository base;
  UserRepository({required this.base});
  
  Future<Either<String, User>?> getUser() async {

    try{
      final dio = await base.dioAccessToken();
      final response = await dio.get("/user/");
      return Right(User.fromJson(response.data));
    }
    catch (error){
      final errorMessages = await onResponseError(error: error);
      if(errorMessages != null) return Left(errorMessages.first);
      return null;
    }
  }
}