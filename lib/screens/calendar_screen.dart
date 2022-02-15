import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/task_bottom_sheet.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/components/calendar/calendar_card.dart';
import 'package:task_manager/components/calendar/calendar_group_hour.dart';
import 'package:task_manager/components/calendar/calendar_month_picker.dart';
import 'package:task_manager/components/calendar/calendar_task_list_item.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/lists/animated_dynamic_task_list.dart';
import 'package:task_manager/components/lists/snap_bounce_scroll_physics.dart';
import 'package:task_manager/components/lists/task_list_item.dart';
import 'package:task_manager/components/main/app_bar.dart';
import 'package:task_manager/components/main/floating_action_button.dart';
import 'package:task_manager/components/responsive/fill_remaining_list.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/shimmer/shimmer_list.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/dynamic_object.dart';
import 'package:task_manager/theme/theme.dart';

import '../constants.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AvailableSpaceCubit()),
        BlocProvider(create: (_) => CalendarBloc(taskBloc: context.read<TaskBloc>())..add(CalendarLoaded(
          startMonth: DateTime(DateTime.now().year, DateTime.now().month - 1),
          endMonth: DateTime(DateTime.now().year, DateTime.now().month + 2),
          selectedDate: getDate(DateTime.now())
        ))),
      ],
      child: _CalendarScreen()
    );
  }
}

class _CalendarScreen extends StatefulWidget{

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<_CalendarScreen>{

  bool scrolledToInitialOffset = false;
  ScrollController scrollController = ScrollController();
  double? tabWidth;

  double appBarHeight = 500.0;
  double contentHeight = 0.0;

  bool showFloatingActionButton = true;

  @override
  Widget build(BuildContext context){
    final customTheme = Theme.of(context).customTheme;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      floatingActionButton: AnimatedFloatingActionButton(
        visible: showFloatingActionButton,
        onPressed: () {
          CalendarState calendarState = BlocProvider.of<CalendarBloc>(context).state;

          ModalBottomSheet(
            title: context.l10n.bottomSheet_createTask,
            context: context,
            content: TaskBottomSheet(
              initialDate: (calendarState is CalendarLoadSuccess) ? calendarState.selectedDay : null,
            ),
          ).show();
        },
      ),

      body: LayoutBuilder(
        builder: (_, constraints){
          
          return BlocBuilder<CalendarBloc, CalendarState>(
            builder: (_, calendarState){

              List<DynamicObject>? items = (calendarState is CalendarLoadSuccess) ? calendarState.items : null;

              return AnimatedFloatingActionButtonScrollNotification(
                currentState: showFloatingActionButton,
                onChange: (value) => setState(() => showFloatingActionButton = value),
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()
                  ),
                  slivers: [

                    SliverAppBar(
                      backgroundColor: customTheme.backgroundColor,
                      collapsedHeight: appBarHeight,
                      flexibleSpace: WidgetSize(
                        onChange: (Size size){
                          setState(() => appBarHeight = size.height);
                          context.read<AvailableSpaceCubit>().setHeight(constraints.maxHeight - size.height - contentHeight);
                        },
                        child: MyAppBar(
                          header: context.l10n.calendarScreen_title,
                          description: context.l10n.calendarScreen_description,
                          onButtonPressed: () {},
                        )
                      )
                    ),

                    SliverToBoxAdapter(
                      child: (calendarState is CalendarLoadSuccess) ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          WidgetSize(
                            onChange: (Size size){
                              setState(() => contentHeight = size.height);
                              context.read<AvailableSpaceCubit>().setHeight(constraints.maxHeight - appBarHeight - size.height);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                                                scrollController.jumpTo((calendarState.selectedDay.day - 1) * size.width);
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

                                SizedBox(height: cPadding - cListItemSpace),
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: cPadding),
                            child: items != null ? AlignedAnimatedSwitcher(
                              alignment: Alignment.topCenter,
                              duration: cTransitionDuration,
                              child: items.isNotEmpty ? AnimatedDynamicTaskList(
                                items: items,
                                taskListItemType: TaskListItemType.Calendar,
                                context: context,
                                onUndoDismissed: (task) => BlocProvider.of<TaskBloc>(context).add(TaskUndoDeleted(task)),
                                objectBuilder: (object){
                                  return (object is DateTime) ? CalendarGroupHour(dateTime: object) : Container();
                                }
                              ) : FillRemainingList(
                                availableSpaceCubit: BlocProvider.of<AvailableSpaceCubit>(context),
                                child: EmptySpace(
                                  svgImage: "assets/svg/completed_tasks.svg",
                                  svgHeight: MediaQuery.of(context).orientation == Orientation.portrait
                                    ? MediaQuery.of(context).size.width * 0.4
                                    : MediaQuery.of(context).size.height * 0.4,
                                  header: context.l10n.emptySpace_youHaventTasksOnThisDay,
                                  description: context.l10n.emptySpace_youHaventTasksOnThisDay_description,
                                )
                              ),
                            ) : Padding(
                              padding: EdgeInsets.only(top: cPadding),
                              child: ShimmerList(
                                minItems: 3,
                                maxItems: 4,
                                child: CalendarTaskListItem(isShimmer: true)
                              ),
                            )
                          ),

                          SizedBox(height: cPadding),
                        ],
                      ) : Container(),
                    ),
                  ]
                ),
              );
            }
          );
        },
      ),
    );
  }
}