import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';

class Category{
  final String uuid;
  final String name;
  final Color color;
  final IconData icon;
  final List<Task> tasks;

  Category({
    required this.uuid,
    this.name = "",
    this.color = const Color(0xFFFC76A1),
    this.icon = Icons.widgets_rounded,
    this.tasks = const []
  });

  int completedTasksCount() => tasks.where((task) => task.completed).length;
  bool allTaskCompleted() => completedTasksCount() == tasks.length;

  Category copyWith({String? name, Color? color, IconData? icon, List<Task>? tasks}){
    return Category(
      uuid: this.uuid,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      tasks: tasks ?? this.tasks
    );
  }
}