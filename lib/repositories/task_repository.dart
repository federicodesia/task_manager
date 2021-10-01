import 'dart:async';

import 'package:task_manager/models/task.dart';

class TaskRepository{

  List<Task> taskList = [];

  Future<List<Task>> fetchTasks() async {
    await Future.delayed(Duration(milliseconds: 500));
    return List.of(_generateTaskList());
  }

  List<Task> _generateTaskList(){
    //taskList.add(Task("Wake up buddy", "", DateTime.now()));
    //taskList.add(Task("Daily workout", "", DateTime.now()));
    //taskList.add(Task("Shrink project kick off", "Skype call, kick off with Elena and Andrew from Shrink", DateTime.now()));
    //taskList.add(Task("Hangouts Sushi", "Lauch with Julia, fight this quarantine with humor", DateTime.now()));
    //taskList.sort((a,b) => a.dateTime.compareTo(b.dateTime));
    return taskList;
  }

  Future<List<Task>> saveTask(Task task) async {
    taskList.add(task);
    taskList.sort((a,b) => a.dateTime.compareTo(b.dateTime));
    return taskList;
  }

  Future<List<Task>> updateTask(Task oldTask, Task taskUpdated) async {
    int index = taskList.indexOf(oldTask);
    taskList.removeAt(index);
    taskList.insert(index, taskUpdated);
    taskList.sort((a,b) => a.dateTime.compareTo(b.dateTime));
    return taskList;
  }

  Future<List<Task>> deleteTask(Task task) async {
    taskList.remove(task);
    taskList.sort((a,b) => a.dateTime.compareTo(b.dateTime));
    return taskList;
  }

  Future<List<Task>> completedTask(Task task, bool value) async {
    int index = taskList.indexOf(task);
    taskList.removeAt(index);
    taskList.insert(taskList.length, task.copyWith(completed: value));
    taskList.sort((a,b) => a.dateTime.compareTo(b.dateTime));
    return taskList;
  }
}