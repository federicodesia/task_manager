import 'package:flutter/material.dart';
import 'package:task_manager/components/list_header.dart';
import 'package:task_manager/components/task_list_item.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/task.dart';

class TodayTab extends StatefulWidget{

  @override
  _TodayTabState createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab>{
  final List<Task> taskList = <Task>[
    Task("Wake up buddy", "", DateTime.now()),
    Task("Morning Run", "", DateTime.now()),
    Task("Daily workout", "", DateTime.now()),
    Task(
      "Shrink project kick off",
      "Skype call, kick off with Elena and Andrew from Shrink",
      DateTime.now()
    ),
    Task(
      "Hangouts Sushi",
      "Lauch with Julia, fight this quarantine with humor",
      DateTime.now(),
      completed: true
    ),
  ];

  List<Widget> widgetList = [];

  bool isToday(DateTime dateTime){
    return DateTime.now().difference(dateTime).inDays == 0;
  }

  @override
  void initState() {
    
    List<Task> tasks = taskList.where((task) => !task.completed && isToday(task.dateTime)).toList();
    if(tasks.length > 0){
      widgetList.add(ListHeader("Tasks"));

      final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
      widgetList.add(
        AnimatedList(
          key: _listKey,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          initialItemCount: tasks.length,
          itemBuilder: (context, index, animation){
            return Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: TaskListItem(tasks[index]),
            );
          },
        )
      );
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: cPadding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgetList
        ),
      ),
    );
  }
}