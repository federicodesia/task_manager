import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:task_manager/helpers/response_errors.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/either.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/base_repository.dart';

class SyncRepository{

  final BaseRepository base;
  SyncRepository({required this.base});

  Future<Either<String, List<T>>?> push<T>({
    required String queryPath,
    required List<T> items
  }) async {
    try{
      final response = await base.dioAccessToken.post(
        "/sync/$queryPath/",
        data: jsonEncode(items)
      );

      return Right(_listFromJson<T>(response.data) ?? []);
    }
    catch (error){
      if(error is DioError){
        final message = error.response?.data["message"];
        if(message is String && message.startsWith("duplicated id")){
          return Left(message.split(":").last);
        }
        else{
          print("error: $message");
        }
      }
      onResponseError(error: error);
    }
  }

  List<T>? _listFromJson<T>(dynamic json){
    try{
      if(T == Task) return List<T>.from(json.map((t) => Task.fromJson(t)));
      if(T == Category) return List<T>.from(json.map((c) => Category.fromJson(c)));
    }
    catch(_){}
  }
}