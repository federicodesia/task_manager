class Task{
  final String uuid;
  final String title;
  final String? description;
  final DateTime dateTime;
  final bool completed;

  Task({ 
    required this.uuid,
    required this.title,
    this.description,
    required this.dateTime,
    this.completed = false 
  });

  Task copyWith({String? title, String? description, DateTime? dateTime, bool? completed}){
    return Task(
      uuid: this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      completed: completed ?? this.completed
    );
  }
}