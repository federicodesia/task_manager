import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/helpers/date_time_helper.dart';

part 'task.g.dart';

@JsonSerializable()
class Task{
  final String id;
  final String? categoryId;
  final String title;
  final String description;
  @JsonKey(fromJson: dateTimefromJson, toJson: dateTimeToJson)
  final DateTime date;
  final bool isCompleted;
  @JsonKey(fromJson: dateTimefromJson, toJson: dateTimeToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: dateTimefromJson, toJson: dateTimeToJson)
  final DateTime updatedAt;
  @JsonKey(fromJson: nullableDateTimefromJson, toJson: nullableDateTimeToJson)
  final DateTime? deletedAt;

  Task({ 
    required this.id,
    this.categoryId,
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt
  });

  Task copyWith({
    String? categoryId = "",
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
    DateTime? deletedAt
  }){
    return Task(
      id: this.id,
      categoryId: categoryId == "" ? this.categoryId : categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: this.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: deletedAt ?? this.deletedAt
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}