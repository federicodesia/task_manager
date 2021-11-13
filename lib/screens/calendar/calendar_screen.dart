import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:task_manager/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:task_manager/components/lists/animated_task_list.dart';
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

  late TabController tabController;
  int currentTab = 0;
  double? tabHeight;
  
  @override
  void initState() {
    tabController = TabController(
      vsync: this,
      length: daysInMonth(DateTime.now()),
      initialIndex: DateTime.now().day
    );

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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: cPadding),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.chevron_left_rounded,
                                            color: Colors.white.withOpacity(0.5),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            child: Text(
                                              (calendarState is CalendarLoadSuccess) ? DateFormat('MMMM y').format(calendarState.date) : "",
                                              style: cTitleTextStyle.copyWith(fontSize: 14.0),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: Colors.white.withOpacity(0.5),
                                          )
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: cPadding),

                                    // Tabs
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Theme(
                                        data: ThemeData(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                        ),
                                        child: TabBar(
                                          controller: tabController,
                                          isScrollable: true,
                                          physics: BouncingScrollPhysics(),

                                          indicatorSize: TabBarIndicatorSize.tab,
                                          indicatorWeight: 0.0,
                                          
                                          indicator: RectangularIndicator(
                                            topLeftRadius: 18.0,
                                            topRightRadius: 18.0,
                                            bottomLeftRadius: 18.0,
                                            bottomRightRadius: 18.0,
                                            color: cPrimaryColor
                                          ),
                                          labelPadding: EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 16.0
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: cPadding),

                                          tabs: List.generate(daysInMonth(DateTime.now()), (index){
                                            DateTime now = DateTime.now();
                                            DateTime dateTime = DateTime(now.year, now.month).add(Duration(days: index));

                                            return Tab(
                                              height: tabHeight ?? 100.0,
                                              child: WidgetSize(
                                                onChange: (Size size){
                                                  setState(() => tabHeight = size.height);
                                                },
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      DateFormat('d').format(dateTime),
                                                      style: cTextStyle.copyWith(
                                                        fontSize: 16.0,
                                                        fontWeight: FontWeight.w500,
                                                        color: index == currentTab ? cTextColor : cLightTextColor
                                                      ),
                                                    ),
                                                    SizedBox(height: 4.0),

                                                    Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        // Text to avoid the width change generated by the names of the days.
                                                        Opacity(
                                                          opacity: 0.0,
                                                          child: Text(
                                                            "aaaa",
                                                            style: cLightTextStyle.copyWith(fontSize: 13.0),
                                                          ),
                                                        ),

                                                        Text(
                                                          DateFormat('E').format(dateTime),
                                                          style: cLightTextStyle.copyWith(
                                                            fontSize: 13.0,
                                                            color: index == currentTab ? cTextColor : cLightTextColor
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                          onTap: (index) {
                                            setState(() => currentTab = index);
                                            DateTime now = DateTime.now();
                                            BlocProvider.of<CalendarBloc>(context).add(
                                              CalendarSelectedDateUpdated(DateTime(now.year, now.month).add(Duration(days: index)))
                                            );
                                          }
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: cPadding - cHeaderPadding),

                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: cPadding),
                                      child: AnimatedTaskList(
                                        headerTitle: "Tasks",
                                        items: (calendarState is CalendarLoadSuccess) ? calendarState.tasks : [],
                                        context: context,
                                        onUndoDismissed: (Task task) {}
                                      ),
                                    )
                                  ],
                                )
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