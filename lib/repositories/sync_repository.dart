import 'dart:async';

import 'package:dio/dio.dart';
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
      final response = await base.dioAccessToken.post(
        "/sync",
        data: {
          "lastSync": DateTimeSerializer().toJson(lastSync ?? DateTime(1970)),
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
        final message = error.response?.data["message"];
        if(message is String && message.startsWith("duplicated")){

          final duplicatedId = message.split(":").last;
          if(message.contains("task")) return Left(Tuple2(duplicatedId, Task));
          if(message.contains("category")) return Left(Tuple2(duplicatedId, Category));
        }
        else print("sync error: $message");
      }
      print("error: $error");
      onResponseError(error: error);
    }
  }
}