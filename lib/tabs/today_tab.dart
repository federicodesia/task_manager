import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/components/cards/progress_summary.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/lists/animated_task_list.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/cubits/app_bar_cubit.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/components/widget_size.dart';
import 'package:task_manager/models/task.dart';

class TodayTab extends StatefulWidget{

  final BuildContext context;
  const TodayTab(this.context);
  

  @override
  _TodayTabState createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab>{
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state){

        if(state is TaskLoadSuccess){
          List<Task> tasksList = state.tasks.where((task) => isToday(task.dateTime)).toList();

          if(tasksList.isEmpty){
            return CenteredWidget(
              child: EmptySpace(
                svgImage: "assets/svg/completed_tasks.svg",
                svgHeight: MediaQuery.of(context).orientation == Orientation.portrait ? 
                          MediaQuery.of(context).size.width * 0.4 :
                          MediaQuery.of(context).size.height * 0.4,
                header: "Start creating your first task",
                description: "Add tasks to organize your day, optimize your time and receive reminders!",
              ),
              context: widget.context
            );
          }
          else{
            return Column(
              children: [
                ProgressSummary(
                  header: "Today's progress summary",
                  completed: tasksList.where((task) => task.completed).length,
                  total: tasksList.length,
                  initialDescription: "Let's start to complete! 🚀",
                  finishedDescription: "You completed all the tasks! 🎉",
                ),

                SizedBox(height: cPadding - cHeaderPadding),
                  
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
          return CenteredWidget(
            child: CircularProgressIndicator(),
            context: widget.context
          );
        }

        /*return AnimatedSwitcher(
          duration: cAnimationDuration,
          child: Align(
            key: key,
            alignment: Alignment.topLeft,
            child: child
          ),
        );*/
      }
    );
  }
}

class CenteredWidget extends StatefulWidget{
  final Widget child;
  final BuildContext context;

  CenteredWidget({this.context, this.child});

  @override
  State<StatefulWidget> createState() => _CenteredWidgetState();
}

class _CenteredWidgetState extends State<CenteredWidget>{
  double childHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    final availableHeight = MediaQuery.of(context).size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom -
      BlocProvider.of<AppBarCubit>(context).state;

    return SizedBox(
      height: availableHeight > childHeight ? availableHeight : childHeight,
      child: Center(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WidgetSize(
                onChange: (Size size) {
                  setState(() => childHeight = size.height);
                },
                child: widget.child,
              )
            ],
          ),
        ),
      ),
    );
  }
}