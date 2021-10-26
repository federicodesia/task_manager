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
    taskList.add(Task(Uuid().v4(), "Wake up buddy", "", DateTime.now()));
    taskList.add(Task(Uuid().v4(),"Daily workout", "", DateTime.now()));
    taskList.add(Task(Uuid().v4(),"Shrink project kick off", "Skype call, kick off with Elena and Andrew from Shrink", DateTime.now()));
    taskList.add(Task(Uuid().v4(),"Hangouts Sushi", "Lauch with Julia, fight this quarantine with humor", DateTime.now()));

    taskList.add(Task(Uuid().v4(),"Wake up buddyy", "", DateTime.now().add(Duration(days: 1, hours: 1))));
    taskList.add(Task(Uuid().v4(),"Daily workout", "", DateTime.now().add(Duration(days: 1, hours: 1))));
    taskList.add(Task(Uuid().v4(),"Shrink project kick off", "Skype call, kick off with Elena and Andrew from Shrink", DateTime.now().add(Duration(days: 1, hours: 1))));
    taskList.add(Task(Uuid().v4(),"Hangouts Sushi", "Lauch with Julia, fight this quarantine with humor", DateTime.now().add(Duration(days: 1, hours: 1))));

    taskList.add(Task(Uuid().v4(),"Wake up buddy", "", DateTime.now().add(Duration(days: 2, hours: 1))));
    taskList.add(Task(Uuid().v4(),"Daily workout", "", DateTime.now().add(Duration(days: 2, hours: 1))));
    taskList.add(Task(Uuid().v4(),"Shrink project kick off", "Skype call, kick off with Elena and Andrew from Shrink", DateTime.now().add(Duration(days: 2, hours: 1))));
    taskList.add(Task(Uuid().v4(),"Hangouts Sushi", "Lauch with Julia, fight this quarantine with humor", DateTime.now().add(Duration(days: 2, hours: 1))));

    taskList.add(Task(Uuid().v4(),"Wake up buddy", "", DateTime.now().add(Duration(days: 3, hours: 1))));
    taskList.add(Task(Uuid().v4(),"Daily workout", "", DateTime.now().add(Duration(days: 3, hours: 1))));
    taskList.add(Task(Uuid().v4(),"Shrink project kick off", "Skype call, kick off with Elena and Andrew from Shrink", DateTime.now().add(Duration(days: 3, hours: 1))));
    taskList.add(Task(Uuid().v4(),"Hangouts Sushi", "Lauch with Julia, fight this quarantine with humor", DateTime.now().add(Duration(days: 3, hours: 1))));
    
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