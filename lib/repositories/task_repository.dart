import 'package:task_manager/repositories/base_repository.dart';

class TaskRepository{

  final BaseRepository base;
  TaskRepository({required this.base});

  /*Future<List<Task>?> getTasks() async {
    try{
      final response = await _dio.get(
        "/",
        options: Options(headers: {"Authorization": "Bearer " + authBloc.state.credentials.accessToken})
      );
      return List<Task>.from(response.data
        .map((task) => Task.fromJson(task))
        .where(((task) => task.id != null))
      );
    }
    catch (error){
      onResponseError(error: error);
    }
  }

  Future<Task?> createTask(Task task) async {
    try{
      final response = await _dio.post(
        "/",
        data: jsonEncode(task),
        options: Options(headers: {"Authorization": "Bearer " + authBloc.state.credentials.accessToken})
      );
      return Task.fromJson(response.data);
    }
    catch (error){
      onResponseError(error: error);
    }
  }

  Future<Task?> updateTask(Task task) async {
    try{
      final response = await _dio.patch(
        "/${task.id}",
        data: jsonEncode(task),
        options: Options(headers: {"Authorization": "Bearer " + authBloc.state.credentials.accessToken})
      );
      return Task.fromJson(response.data);
    }
    catch (error){
      onResponseError(error: error);
    }
  }

  Future<Task?> deleteTask(Task task) async {
    try{
      final response = await _dio.delete(
        "/${task.id}",
        data: jsonEncode(task),
        options: Options(headers: {"Authorization": "Bearer " + authBloc.state.credentials.accessToken})
      );
      return Task.fromJson(response.data);
    }
    catch (error){
      onResponseError(error: error);
    }
  }*/
}