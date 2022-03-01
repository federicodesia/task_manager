import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/serializers/datetime_serializer.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@JsonSerializable()
class Task extends Equatable{
  final String id;
  final String? categoryId;
  final String title;
  final String description;
  @DateTimeSerializer()
  final DateTime date;
  final bool isCompleted;
  @DateTimeSerializer()
  final DateTime createdAt;
  @DateTimeSerializer()
  final DateTime updatedAt;
  @NullableDateTimeSerializer()
  final DateTime? deletedAt;

  const Task({ 
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

  static Task create({
    String? categoryId,
    required String title,
    required String description,
    required DateTime date,
    bool isCompleted = false
  }){
    return Task(
      id: const Uuid().v4(),
      categoryId: categoryId,
      title: title,
      description: description,
      date: date,
      isCompleted: isCompleted,
      createdAt: DateTime.now().copyWith(microsecond: 0),
      updatedAt: DateTime.now().copyWith(microsecond: 0)
    );
  }

  Task copyWith({
    String? id,
    String? categoryId = "",
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
    DateTime? deletedAt
  }){
    return Task(
      id: id ?? this.id,
      categoryId: categoryId == "" ? this.categoryId : categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      updatedAt: DateTime.now().copyWith(microsecond: 0),
      deletedAt: deletedAt ?? this.deletedAt
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @override
  List<Object?> get props => [id, categoryId, title, description, date, isCompleted, createdAt, updatedAt, deletedAt];

  @override
  bool get stringify => true;
}