import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';

class Category{
  final String? uuid;
  final String name;
  final Color color;
  final List<Task> tasks;

  Category({
    required this.uuid,
    this.name = "",
    this.color = const Color(0xFFFC76A1),
    this.tasks = const []
  });

  bool get isGeneral => uuid == null;

  Category copyWith({String? name, Color? color, List<Task>? tasks}){
    return Category(
      uuid: this.uuid,
      name: name ?? this.name,
      color: color ?? this.color,
      tasks: tasks ?? this.tasks
    );
  }
}