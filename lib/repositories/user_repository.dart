import 'dart:async';

import 'package:task_manager/helpers/response_errors.dart';
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
}