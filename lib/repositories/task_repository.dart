import 'dart:async';

import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:uuid/uuid.dart';

class TaskRepository{

  Future<List<Task>> fetchTasks() async{

    await Future.delayed(Duration(milliseconds: 500));
    final List<Task> taskList = [];

    taskList.add(Task(uuid: Uuid().v4(), title: "Wake up buddy")..setDateTime(copyDateTimeWith(DateTime.now(), hour: 7)));
    taskList.add(Task(uuid: Uuid().v4(), title: "Daily workout")..setDateTime(copyDateTimeWith(DateTime.now(), hour: 7)));
    taskList.add(Task(uuid: Uuid().v4(), title: "Shrink project kick off", description: "Skype call, kick off with Elena and Andrew from Shrink")..setDateTime(copyDateTimeWith(DateTime.now(), hour: 10)));
    taskList.add(Task(uuid: Uuid().v4(), title: "Hangouts Sushi", description: "Lauch with Julia, fight this quarantine with humor")..setDateTime(copyDateTimeWith(DateTime.now(), hour: 12)));
    
    final List<Task> taskListTwo = [];

    for(int i = 0; i < 3; i++){
      for(int j = 0; j < taskList.length; j++){
        final task = taskList[j];

        String taskTitle = task.title;
        String lastCharacter = taskTitle.substring(taskTitle.length - 1, taskTitle.length);

        String newTaskTitle = taskTitle;
        for(int k = 0; k < i + 1; k++){
          newTaskTitle += lastCharacter;
        }

        taskListTwo.add(Task(
          uuid: Uuid().v4(),
          title: newTaskTitle,
          description: task.description,
        )..setDateTime(task.dateTime.add(Duration(days: i + 1))));
      }
    }
    taskList.addAll(taskListTwo);
    return taskList;
  }
}