import 'dart:async';

import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:uuid/uuid.dart';

class TaskRepository{

  Future<List<Task>> fetchTasks() async{

    await Future.delayed(Duration(milliseconds: 500));
    final List<Task> taskList = [];

    taskList.add(Task(uuid: Uuid().v4(), title: "Wake up buddy", categoryUuid: "520b1787-46e5-4aa4-84fe-4a7d267b84a7", completed: true)..setDateTime(copyDateTimeWith(DateTime.now(), hour: 7)));
    taskList.add(Task(uuid: Uuid().v4(), title: "Daily workout", categoryUuid: "520b1787-46e5-4aa4-84fe-4a7d267b84a7")..setDateTime(copyDateTimeWith(DateTime.now(), hour: 7)));
    taskList.add(Task(uuid: Uuid().v4(), title: "Shrink project kick off", description: "Skype call, kick off with Elena and Andrew from Shrink", categoryUuid: "b2d60aa1-27b7-45c3-8f92-39f66ec7ed27")..setDateTime(copyDateTimeWith(DateTime.now(), hour: 10)));
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
          completed: false
        )..setDateTime(task.dateTime.add(Duration(days: i + 1))));
      }
    }
    taskList.addAll(taskListTwo);
    return taskList;
  }
}