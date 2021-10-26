class Task{
  final String uuid;
  final String title;
  final String description;
  final DateTime dateTime;
  final bool completed;

  Task(
    this.uuid,
    this.title,
    this.description,
    this.dateTime,
    { this.completed = false }
  );

  Task copyWith({String title, String description, DateTime dateTime, bool completed}){
    return Task(
      uuid,
      title ?? this.title,
      description ?? this.description,
      dateTime ?? this.dateTime,
      completed: completed ?? this.completed
    );
  }
}