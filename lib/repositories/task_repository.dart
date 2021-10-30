import 'dart:async';

import 'package:task_manager/models/task.dart';
import 'package:uuid/uuid.dart';

class TaskRepository{

  List<Task> taskList = [];

  Future<List<Task>> fetchTasks() async {
    await Future.delayed(Duration(milliseconds: 500));
    return List.of(_generateTaskList());
  }

  List<Task> _generateTaskList(){
    taskList.add(Task(uuid: Uuid().v4(), title: "Wake up buddy", description: "", dateTime: DateTime.now()));
    taskList.add(Task(uuid: Uuid().v4(), title: "Daily workout", description: "", dateTime: DateTime.now()));
    taskList.add(Task(uuid: Uuid().v4(), title: "Shrink project kick off", description: "Skype call, kick off with Elena and Andrew from Shrink", dateTime: DateTime.now()));
    taskList.add(Task(uuid: Uuid().v4(), title: "Hangouts Sushi", description: "Lauch with Julia, fight this quarantine with humor", dateTime: DateTime.now()));

    taskList.add(Task(uuid: Uuid().v4(), title: "Wake up buddyy", description: "", dateTime: DateTime.now().add(Duration(days: 1, hours: 1))));
    taskList.add(Task(uuid: Uuid().v4(), title: "Daily workout", description: "", dateTime: DateTime.now().add(Duration(days: 1, hours: 1))));
    taskList.add(Task(uuid: Uuid().v4(), title: "Shrink project kick off", description: "Skype call, kick off with Elena and Andrew from Shrink", dateTime: DateTime.now().add(Duration(days: 1, hours: 1))));
    taskList.add(Task(uuid: Uuid().v4(), title: "Hangouts Sushi", description: "Lauch with Julia, fight this quarantine with humor", dateTime: DateTime.now().add(Duration(days: 1, hours: 1))));

    taskList.add(Task(uuid: Uuid().v4(), title: "Wake up buddy", description: "", dateTime: DateTime.now().add(Duration(days: 2, hours: 1))));
    taskList.add(Task(uuid: Uuid().v4(), title: "Daily workout", description: "", dateTime: DateTime.now().add(Duration(days: 2, hours: 1))));
    taskList.add(Task(uuid: Uuid().v4(), title: "Shrink project kick off", description: "Skype call, kick off with Elena and Andrew from Shrink", dateTime: DateTime.now().add(Duration(days: 2, hours: 1))));
    taskList.add(Task(uuid: Uuid().v4(), title: "Hangouts Sushi", description: "Lauch with Julia, fight this quarantine with humor", dateTime: DateTime.now().add(Duration(days: 2, hours: 1))));

    taskList.add(Task(uuid: Uuid().v4(), title: "Wake up buddy", description: "", dateTime: DateTime.now().add(Duration(days: 3, hours: 1))));
    taskList.add(Task(uuid: Uuid().v4(), title: "Daily workout", description: "", dateTime: DateTime.now().add(Duration(days: 3, hours: 1))));
    taskList.add(Task(uuid: Uuid().v4(), title: "Shrink project kick off", description: "Skype call, kick off with Elena and Andrew from Shrink", dateTime: DateTime.now().add(Duration(days: 3, hours: 1))));
    taskList.add(Task(uuid: Uuid().v4(), title: "Hangouts Sushi", description: "Lauch with Julia, fight this quarantine with humor", dateTime: DateTime.now().add(Duration(days: 3, hours: 1))));
    
    taskList.sort((a,b) => a.dateTime.compareTo(b.dateTime));
    return taskList;
  }

  Future<List<Task>> saveTask(Task task) async {
    taskList.add(task);
    taskList.sort((a,b) => a.dateTime.compareTo(b.dateTime));
    return taskList;
  }

  Future<List<Task>> updateTask(Task oldTask, Task taskUpdated) async {
    taskList.remove(oldTask);
    taskList.add(taskUpdated);
    taskList.sort((a,b) => a.dateTime.compareTo(b.dateTime));
    return taskList;
  }

  Future<List<Task>> deleteTask(Task task) async {
    taskList.remove(task);
    taskList.sort((a,b) => a.dateTime.compareTo(b.dateTime));
    return taskList;
  }

  Future<List<Task>> completedTask(Task task, bool value) async {
    taskList.remove(task);
    taskList.add(task.copyWith(completed: value));

    taskList.sort((a,b) => a.dateTime.compareTo(b.dateTime));
    return taskList;
  }
}