import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/blocs/upcoming_bloc/upcoming_bloc.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/components/charts/week_bar_chat.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/lists/animated_dynamic_task_list.dart';
import 'package:task_manager/components/lists/list_header.dart';
import 'package:task_manager/components/lists/task_list_item.dart';
import 'package:task_manager/components/responsive/centered_list_widget.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/dynamic_object.dart';
import 'package:task_manager/models/task.dart';

class UpcomingTab extends StatefulWidget{

  @override
  _UpcomingTabState createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<UpcomingTab>{

  late Widget child;
  double weekBarChartHeight = 0.0;

  @override
  Widget build(BuildContext buildContext) {
    
    return BlocBuilder<UpcomingBloc, UpcomingState>(
      builder: (_, state){

        if(state is UpcomingLoadSuccess){

          List<Task> weekTasksList = state.weekTasks;
          List<DynamicObject> items = state.items;

          if(weekTasksList.isEmpty && items.isEmpty){
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

                if(items.isNotEmpty) AnimatedDynamicTaskList(
                  items: items,
                  taskListItemType: TaskListItemType.Checkbox,
                  compareTaskUuid: true,
                  context: context,
                  onUndoDismissed: (task) => BlocProvider.of<TaskBloc>(context).add(TaskAdded(task)),
                  objectBuilder: (object){
                    if(object is DateTime){
                      DateTime now = DateTime.now();
                      DateTime dateTime = object;

                      String header;
                      if(dateDifference(dateTime, now) == 1) header = "Tomorrow";
                      else if(dateTime.year != now.year) header = DateFormat('E, dd MMM y').format(dateTime);
                      else header = DateFormat('E, dd MMM').format(dateTime);

                      return ListHeader(header);
                    }
                    return Container();
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