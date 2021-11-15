import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:task_manager/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:task_manager/components/calendar/calendar_card.dart';
import 'package:task_manager/components/calendar/calendar_month_picker.dart';
import 'package:task_manager/components/lists/animated_task_list.dart';
import 'package:task_manager/components/responsive/centered_list_widget.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/app_bar_cubit.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';

import '../../constants.dart';
import 'calendar_app_bar.dart';

class CalendarScreen extends StatefulWidget{

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with TickerProviderStateMixin{

  int currentTab = 0;
  double? tabHeight;

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

                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(horizontal: cPadding),
                                      physics: BouncingScrollPhysics(),
                                      child: Row(
                                        children: List.generate(calendarState.days.length, (index){
                                          return WidgetSize(
                                            onChange: (Size size){
                                              setState(() => tabHeight = size.height);
                                            },
                                            child: GestureDetector(
                                              child: CalendarCard(
                                                dateTime: calendarState.days[index],
                                                isSelected: calendarState.days[index].compareTo(calendarState.selectedDay) == 0,
                                              ),
                                              onTap: (){
                                                BlocProvider.of<CalendarBloc>(context).add(CalendarDateUpdated(calendarState.days[index]));
                                              },
                                            ),
                                          );
                                        }),
                                      ),
                                    ),

                                    SizedBox(height: cPadding - cHeaderPadding),

                                    calendarState.tasks.isNotEmpty ? Padding(
                                      padding: EdgeInsets.symmetric(horizontal: cPadding),
                                      child: AnimatedTaskList(
                                        headerTitle: "Tasks",
                                        items: calendarState.tasks,
                                        context: context,
                                        onUndoDismissed: (Task task) {}
                                      ),
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