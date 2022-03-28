import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/helpers/response_errors.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/either.dart';
import 'package:task_manager/models/serializers/datetime_serializer.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/base_repository.dart';
import 'package:tuple/tuple.dart';

class SyncRepository{

  final BaseRepository base;
  SyncRepository({required this.base});

  Future<Either<
    Tuple2<String, Object>,
    Tuple2<List<Task>, List<Category>>
  >?> sync({
    required DateTime? lastSync,
    required List<Task> tasks,
    required List<Category> categories
  }) async {
    try{

      final dio = await base.dioAccessToken;
      final response = await dio.post(
        "/sync",
        data: {
          "lastSync": const NullableDateTimeSerializer().toJson(lastSync),
          "tasks": tasks,
          "categories": categories
        }
      );

      return Right(Tuple2(
        List<Task>.from(response.data["tasks"].map((t) => Task.fromJson(t))),
        List<Category>.from(response.data["categories"].map((c) => Category.fromJson(c)))
      ));
    }
    catch (error){
      if(error is DioError){

        final dioError = error.response?.data["message"];
        debugPrint("SyncRepository | DioError: $dioError");
      }
      else{
        debugPrint("SyncRepository | Error: $error");
      }

      final responseMessage = await ResponseError.validate(error, ["duplicated"]);
      if(responseMessage == null) return null;

      String? duplicatedMessage = responseMessage.get("duplicated");
      if(duplicatedMessage == null) return null;

      final duplicatedId = duplicatedMessage.split(":").last;
      
      duplicatedMessage = duplicatedMessage.toLowerCase();
      if(duplicatedMessage.contains("task")) return Left(Tuple2(duplicatedId, Task));
      if(duplicatedMessage.contains("category")) return Left(Tuple2(duplicatedId, Category));
    }
    return null;
  }
}