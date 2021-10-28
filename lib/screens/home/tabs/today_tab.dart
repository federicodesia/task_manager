import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/components/cards/progress_summary.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/lists/animated_task_list.dart';
import 'package:task_manager/components/responsive/centered_list_widget.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';

class TodayTab extends StatefulWidget{

  @override
  _TodayTabState createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab>{

  Widget child;
  double progressSummaryHeight = 0.0;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (_, state){

        if(state is TaskLoadSuccess){
          List<Task> tasksList = state.tasks;

          if(tasksList.isEmpty){
            child = CenteredListWidget(
              child: EmptySpace(
                svgImage: "assets/svg/completed_tasks.svg",
                svgHeight: MediaQuery.of(context).orientation == Orientation.portrait ? 
                          MediaQuery.of(context).size.width * 0.4 :
                          MediaQuery.of(context).size.height * 0.4,
                header: "Start creating your first task",
                description: "Add tasks to organize your day, optimize your time and receive reminders!",
              ),
            );
          }
          else{
            List<Task> todayTasks = tasksList.where((task) => dateDifference(task.dateTime, DateTime.now()) == 0).toList();
            List<Task> completedTasks = todayTasks.where((task) => task.completed).toList();

            child = Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WidgetSize(
                  onChange: (Size size){
                    setState(() => progressSummaryHeight = size.height);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: ProgressSummary(
                      header: "Today's progress summary",
                      completed: completedTasks.length,
                      total: todayTasks.length,
                      initialDescription: "Let's start to complete! 🚀",
                      finishedDescription: "You completed all the tasks! 🎉",
                    ),
                  ),
                ),

                if(todayTasks.length > 0) Column(
                  children: [
                    AnimatedTaskList(
                      headerTitle: "Tasks",
                      items: todayTasks.where((task) => !task.completed).toList(),
                      context: context,
                      onUndoDismissed: (task) => BlocProvider.of<TaskBloc>(context).add(TaskAdded(task))
                    ),

                    AnimatedTaskList(
                      headerTitle: "Completed",
                      items: completedTasks,
                      context: context,
                      onUndoDismissed: (task) => BlocProvider.of<TaskBloc>(context).add(TaskAdded(task))
                    )
                  ],
                )
                else CenteredListWidget(
                  subtractHeight: progressSummaryHeight,
                  child: EmptySpace(
                    header: "You haven't tasks for today!",
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