import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/components/charts/week_bar_chat.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/lists/animated_task_list.dart';
import 'package:task_manager/components/responsive/centered_list_widget.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/tasks_group_date.dart';

class UpcomingTab extends StatefulWidget{

  @override
  _UpcomingTabState createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<UpcomingTab>{

  late Widget child;
  double weekBarChartHeight = 0.0;

  @override
  Widget build(BuildContext buildContext) {
    
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (_, state){

        if(state is TaskLoadSuccess){

          List<Task> tasksList = state.tasks;

          List<Task> weekTasksList = tasksList.where((task){
            final weekday = DateTime.now().weekday - 1;
            final difference = task.dateTime.difference(DateTime.now()).inDays;
            return difference >= weekday * -1 && difference < 7 - weekday;
          }).toList();

          List<TaskGroupDate> taskGroups = [];
          if(tasksList.length > 0){
            taskGroups.add(
              TaskGroupDate(
                dateTime: getDate(tasksList.first.dateTime),
                tasks: []
              )
            );

            for(int i = 0; i < tasksList.length; i++){
              Task task = tasksList[i];
              TaskGroupDate group = taskGroups.last;

              if(dateDifference(task.dateTime, taskGroups.last.dateTime) == 0) group.tasks.add(task);
              else if(taskGroups.length - 1 == 3) break;
              else{
                taskGroups.add(
                  TaskGroupDate(
                    dateTime: getDate(task.dateTime),
                    tasks: [
                      task
                    ]
                  )
                );
              }
            }

            // Ignore today tasks
            if(dateDifference(taskGroups.first.dateTime, DateTime.now()) == 0){
              taskGroups.remove(taskGroups.first);
            }
          }

          if(weekTasksList.isEmpty && taskGroups.isEmpty){
            child = CenteredListWidget(
              child: EmptySpace(
                svgImage: "assets/svg/completed_tasks.svg",
                svgHeight: MediaQuery.of(context).orientation == Orientation.portrait ? 
                          MediaQuery.of(context).size.width * 0.4 :
                          MediaQuery.of(context).size.height * 0.4,
                header: "You haven't tasks for later!",
                description: "Add tasks to organize your day, optimize your time and receive reminders!",
              ),
            );
          }
          else{
            child = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if(weekTasksList.isNotEmpty) WidgetSize(
                  onChange: (Size size){
                    setState(() => weekBarChartHeight = size.height);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: WeekBarChart(
                      header: "Tasks in this week",
                      weekTasksList: weekTasksList,
                    ),
                  ),
                ),

                if(taskGroups.length > 0) ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: taskGroups.length,
                  itemBuilder: (_, groupIndex){
                    
                    DateTime nowDateTime = DateTime.now();
                    DateTime groupDateTime = taskGroups[groupIndex].dateTime;
                    String header;
                    if(dateDifference(groupDateTime, nowDateTime) == 1) header = "Tomorrow";
                    else if(groupDateTime.year != nowDateTime.year) header = DateFormat('E, dd MMM y').format(groupDateTime);
                    else header = DateFormat('E, dd MMM').format(groupDateTime);

                    return AnimatedTaskList(
                      headerTitle: header,
                      items: taskGroups[groupIndex].tasks,
                      context: context,
                      onUndoDismissed: (task) => BlocProvider.of<TaskBloc>(context).add(TaskAdded(task))
                    );
                  }
                )
                else CenteredListWidget(
                  subtractHeight: weekBarChartHeight,
                  child: EmptySpace(
                    header: "You haven't tasks for later!",
                    description: "Add tasks to organize your day, optimize your time and receive reminders!",
                  ),
                )
              ],
            );
          }
        }
        else{
          child = CenteredListWidget(
            child: CircularProgressIndicator(),
          );
        }

        return AlignedAnimatedSwitcher(
          child: child,
        );
      }
    );
  }
}