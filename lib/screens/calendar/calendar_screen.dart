import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/components/calendar/calendar_card.dart';
import 'package:task_manager/components/calendar/calendar_month_picker.dart';
import 'package:task_manager/components/lists/animated_task_list.dart';
import 'package:task_manager/components/lists/snap_bounce_scroll_physics.dart';
import 'package:task_manager/components/responsive/centered_list_widget.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/app_bar_cubit.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/tasks_group_hour.dart';

import '../../constants.dart';
import 'calendar_app_bar.dart';

class CalendarScreen extends StatefulWidget{

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with TickerProviderStateMixin{

  bool scrolledToInitialOffset = false;
  ScrollController scrollController = ScrollController();
  double? tabWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: LayoutBuilder(
        builder: (_, constraints){
          
          return BlocBuilder<AppBarCubit, double>(
            builder: (_, appBarState) {

              return BlocBuilder<CalendarBloc, CalendarState>(
                builder: (_, calendarState){

                  List<Task> tasksList = (calendarState is CalendarLoadSuccess) ? calendarState.tasks : []; 
                  tasksList.sort((a, b) => a.dateTime.compareTo(b.dateTime));

                  List<TaskGroupHour> taskGroups = [];
                  
                  if(tasksList.length > 0){
                    for(int i = tasksList.first.dateTime.hour; i <= tasksList.last.dateTime.hour; i++){
                      taskGroups.add(
                        TaskGroupHour(
                          hour: copyDateTimeWith(
                            tasksList.first.dateTime,
                            hour: i
                          ),
                          tasks: tasksList.where((task) => task.dateTime.hour == i).toList()
                        )
                      );
                    }
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()
                          ),
                          slivers: [

                            SliverAppBar(
                              backgroundColor: cBackgroundColor,
                              collapsedHeight: appBarState,
                              flexibleSpace: WidgetSize(
                                onChange: (Size size) => BlocProvider.of<AppBarCubit>(context).emit(size.height),
                                child: CalendarAppBar(
                                  header: "Calendar",
                                  description: "Let's organize!"
                                )
                              )
                            ),

                            SliverToBoxAdapter(
                              child: WidgetSize(
                                onChange: (Size size) => BlocProvider.of<AvailableSpaceCubit>(context).emit(constraints.maxHeight - size.height),
                                child: (calendarState is CalendarLoadSuccess) ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: cPadding),
                                      child: CalendarMonthPicker(
                                        months: calendarState.months,
                                        initialMonth: DateTime.now(),
                                        onChanged: (date){
                                          BlocProvider.of<CalendarBloc>(context).add(CalendarMonthUpdated(date));
                                        },
                                      ),
                                    ),

                                    SizedBox(height: 8.0),

                                    NotificationListener<ScrollEndNotification>(
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 2 - (tabWidth ?? 100.0) / 2),
                                        physics: tabWidth != null ? SnapBounceScrollPhysics(
                                          itemWidth: tabWidth!
                                        ) : BouncingScrollPhysics(),
                                        child: Row(
                                          children: List.generate(calendarState.days.length, (index){
                                            DateTime day = calendarState.days[index];

                                            return WidgetSize(
                                              onChange: (Size size){
                                                setState(() {
                                                  tabWidth = size.width;
                                                  if(!scrolledToInitialOffset){
                                                    scrollController.animateTo(
                                                      (calendarState.selectedDay.day - 1) * size.width,
                                                      duration: cAnimationDuration,
                                                      curve: Curves.ease
                                                    );
                                                    scrolledToInitialOffset = true;
                                                  }
                                                });
                                              },
                                              child: CalendarCard(
                                                dateTime: day,
                                                isSelected: day.compareTo(calendarState.selectedDay) == 0,
                                                onTap: () {
                                                  BlocProvider.of<CalendarBloc>(context).add(CalendarDateUpdated(day));
                                                  scrollController.animateTo(
                                                    index * (tabWidth ?? 100),
                                                    duration: cAnimationDuration,
                                                    curve: Curves.ease
                                                  );
                                                },
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                      onNotification: (notification){
                                        DateTime day = calendarState.days[scrollController.position.pixels ~/ (tabWidth ?? 100)];
                                        BlocProvider.of<CalendarBloc>(context).add(CalendarDateUpdated(day));
                                        return true;
                                      }
                                    ),

                                    SizedBox(height: cPadding - cHeaderPadding),

                                    calendarState.tasks.isNotEmpty ? Padding(
                                      padding: EdgeInsets.symmetric(horizontal: cPadding),
                                      child: Column(
                                        children: List.generate(taskGroups.length, (index){
                                          TaskGroupHour group = taskGroups[index];

                                          return Padding(
                                            padding: EdgeInsets.symmetric(vertical: 14.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Text(
                                                      DateFormat("HH:00").format(group.hour).toLowerCase(),
                                                      style: cLightTextStyle.copyWith(fontWeight: FontWeight.w300),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),

                                                    Opacity(
                                                      opacity: 0,
                                                      child: Text(
                                                        "12:00 ",
                                                        style: cLightTextStyle.copyWith(fontWeight: FontWeight.w300),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                ),

                                                SizedBox(width: 12.0),

                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Stack(
                                                        alignment: Alignment.center,
                                                        children: [
                                                          Container(
                                                            height: 1,
                                                            color: Colors.white.withOpacity(0.08),
                                                          ),

                                                          Opacity(
                                                            opacity: 0,
                                                            child: Text("a", style: cLightTextStyle),
                                                          )
                                                        ],
                                                      ),

                                                      if(group.tasks.isNotEmpty) Padding(
                                                        padding: EdgeInsets.only(top: 4.0),
                                                        child: AnimatedTaskList(
                                                          items: group.tasks,
                                                          type: TaskListItemType.Calendar,
                                                          context: context,
                                                          onUndoDismissed: (task) => BlocProvider.of<TaskBloc>(context).add(TaskAdded(task))
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                      )
                                    ) : Container()
                                  ],
                                ) : CenteredListWidget(child: CircularProgressIndicator())
                              ),
                            ),
                          ]
                        ),
                      ),
                    ],
                  );
                }
              );
            },
          );
        },
      ),
    );
  }
}