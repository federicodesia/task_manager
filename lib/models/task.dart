import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task{
  final String? id;
  final String? categoryId;
  final String title;
  final String description;
  final DateTime date;
  final bool isCompleted;

  Task({ 
    this.id,
    this.categoryId,
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false
  });

  Task copyWith({
    String? categoryId = "",
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted
  }){
    return Task(
      id: this.id,
      categoryId: categoryId == "" ? this.categoryId : categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}