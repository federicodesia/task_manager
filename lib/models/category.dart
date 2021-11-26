import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';

class Category{
  final String name;
  final Color color;
  final IconData icon;
  final List<Task> tasks;

  Category({
    required this.name,
    this.color = const Color(0xFFFC76A1),
    this.icon = Icons.category_rounded,
    this.tasks = const []
  });

  int completedTasksCount() => tasks.where((task) => task.completed).length;
  bool allTaskCompleted() => completedTasksCount() == tasks.length;

  Category copyWith({String? name, Color? color, IconData? icon, List<Task>? tasks}){
    return Category(
      name: this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      tasks: tasks ?? this.tasks
    );
  }
}

List<Category> categoryList = <Category>[
  Category(
    name: "School",
    icon: Icons.auto_stories_rounded
  ),

  Category(
    name: "Perosonal",
    color: Color(0xFF6FC4BE),
    icon: Icons.person_rounded
  ),

  Category(
    name: "Design",
    color: Color(0xFFAD6DDE),
    icon: Icons.brush_rounded
  ),

  Category(
    name: "Groceries",
    color: Color(0xFFCFB452),
    icon: Icons.shopping_cart_rounded
  ),
];
