import 'dart:async';

import 'package:task_manager/models/task.dart';

class TaskRepository{

  List<Task> taskList = [];

  Future<List<Task>> fetchTasks() async {
    await Future.delayed(Duration(seconds: 1));
    return List.of(_generateTaskList());
  }

  List<Task> _generateTaskList(){
    taskList.add(Task("Wake up buddy", "", DateTime.now()));
    taskList.add(Task("Daily workout", "", DateTime.now()));
    taskList.add(Task("Shrink project kick off", "Skype call, kick off with Elena and Andrew from Shrink", DateTime.now()));
    taskList.add(Task("Hangouts Sushi", "Lauch with Julia, fight this quarantine with humor", DateTime.now()));
    return taskList;
  }

  Future<List<Task>> saveTask(Task task) async {
    taskList.add(task);
    return taskList;
  }

  Future<List<Task>> updateTask(Task oldTask, Task taskUpdated) async {
    int index = taskList.indexOf(oldTask);
    taskList.removeAt(index);
    taskList.insert(index, taskUpdated);
    return taskList;
  }

  Future<List<Task>> deleteTask(Task task) async {
    taskList.remove(task);
    return taskList;
  }

  Future<List<Task>> completedTask(Task task, bool value) async {
    int index = taskList.indexOf(task);
    taskList.removeAt(index);
    taskList.insert(taskList.length, task.copyWith(completed: value));
    return taskList;
  }

  Future<List<Task>> undoDeleteTask(Task task, int index) async {
    taskList.insert(index, task);
    return taskList;
  }
}