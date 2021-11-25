import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:task_manager/components/calendar/calendar_card.dart';
import 'package:task_manager/components/calendar/calendar_group_hour.dart';
import 'package:task_manager/components/calendar/calendar_month_picker.dart';
import 'package:task_manager/components/lists/declarative_animated_list.dart';
import 'package:task_manager/components/lists/list_item_animation.dart';
import 'package:task_manager/components/lists/snap_bounce_scroll_physics.dart';
import 'package:task_manager/components/main/app_bar.dart';
import 'package:task_manager/components/responsive/centered_list_widget.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/app_bar_cubit.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/tasks_group_hour.dart';

import '../../constants.dart';

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

                  List<TaskGroupHour> groups = (calendarState is CalendarLoadSuccess) ? calendarState.groups : [];

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
                                child: MyAppBar(
                                  header: "Calendar",
                                  description: "Let's organize!",
                                  onButtonPressed: () {},
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
                                          int previousIndex = scrollController.offset ~/ tabWidth!;
                                          int previousLenght = calendarState.days.length;
                                          int nowLenght = daysInMonth(date);
                                          BlocProvider.of<CalendarBloc>(context).add(CalendarMonthUpdated(date));
                                          
                                          int index;
                                          if(previousIndex > previousLenght - 1) index = nowLenght - 1;
                                          else index = previousIndex.clamp(0, nowLenght - 1);

                                          scrollController.animateTo(
                                            index * tabWidth! - 0.001,
                                            duration: cAnimationDuration,
                                            curve: Curves.ease
                                          );
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

                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: cPadding),
                                      child: DeclarativeAnimatedList(
                                        items: groups,
                                        equalityCheck: (TaskGroupHour a, TaskGroupHour b) => a.hour.hour == b.hour.hour,
                                        itemBuilder: (BuildContext context, TaskGroupHour group, int index, Animation<double> animation){
                                          return ListItemAnimation(
                                            animation: animation,
                                            child: CalendarGroupHour(
                                              group: group,
                                              context: context,
                                            ),
                                          );
                                        },
                                      )
                                    ),

                                    SizedBox(height: cPadding),
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