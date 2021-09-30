import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/components/lists/animated_task_list.dart';
import 'package:task_manager/constants.dart';

class TodayTab extends StatefulWidget{

  @override
  _TodayTabState createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab>{
  
  bool isToday(DateTime dateTime){
    return DateTime.now().difference(dateTime).inDays == 0;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state){

        if(state is TaskLoadSuccess){
          if(state.tasks.isEmpty){
            return Center(child: Text("No content"));
          }

          return ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: cPadding),
            children: [
              AnimatedTaskList(
                headerTitle: "Tasks",
                items: state.tasks.where((task) => !task.completed && isToday(task.dateTime)).toList(),
                context: context,
              ),

              AnimatedTaskList(
                headerTitle: "Completed",
                items: state.tasks.where((task) => task.completed && isToday(task.dateTime)).toList(),
                context: context,
              )
            ],
          );
        }

        return Center(child: CircularProgressIndicator());
      }
    );
  }
}