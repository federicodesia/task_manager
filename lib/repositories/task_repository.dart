import 'dart:async';

import 'package:task_manager/models/task.dart';
import 'package:uuid/uuid.dart';

class TaskRepository{

  Future<List<Task>> fetchTasks() async{

    await Future.delayed(Duration(milliseconds: 500));
    final List<Task> taskList = [];

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
    
    return taskList;
  }
}