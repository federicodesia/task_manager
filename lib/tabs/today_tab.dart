import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/lists/animated_task_list.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/task.dart';

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

        Widget child;

        if(state is TaskLoadSuccess){
          List<Task> tasksList = state.tasks.where((task) => isToday(task.dateTime)).toList();

          if(tasksList.isEmpty){
            child = Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(cPadding),
                physics: BouncingScrollPhysics(),
                child: EmptySpace(
                  svgImage: "assets/svg/completed_tasks.svg",
                  svgHeight: MediaQuery.of(context).size.width * 0.4,
                  header: "Start creating your first task",
                  description: "Add tasks to organize your day, optimize your time and receive reminders!",
                ),
              ),
            );
          }
          else{
            child = ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: cPadding),
              children: [
                AnimatedTaskList(
                  headerTitle: "Tasks",
                  items: tasksList.where((task) => !task.completed).toList(),
                  context: context,
                ),

                AnimatedTaskList(
                  headerTitle: "Completed",
                  items: tasksList.where((task) => task.completed).toList(),
                  context: context,
                )
              ],
            );
          }
        }
        else{
          child = Center(child: CircularProgressIndicator());
        }

        return AnimatedSwitcher(
          duration: Duration(milliseconds: 400),
          child: Align(
            alignment: Alignment.topLeft,
            child: child
          ),
        );
      }
    );
  }
}