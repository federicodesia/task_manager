import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
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
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/theme/theme.dart';

import '../constants.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AvailableSpaceCubit()),
        BlocProvider(create: (_) => CalendarBloc(
          taskBloc: context.read<TaskBloc>(),
          categoryBloc: context.read<CategoryBloc>()
        )),
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

  late CalendarBloc calendarBloc = context.read<CalendarBloc>();
  late StreamSubscription calendarSubscription;

  @override
  void initState() {
    calendarSubscription = calendarBloc.stream.listen((calendarState) {
      if(tabWidth != null){
        scrollController.animateTo(
          (calendarState.selectedDay.day - 1) * tabWidth!,
          duration: cAnimationDuration,
          curve: Curves.ease
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    calendarSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final customTheme = Theme.of(context).customTheme;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      floatingActionButton: TaskFloatingActionButton(
        visible: showFloatingActionButton,
        onPressed: () {
          TaskBottomSheet(
            context,
            initialDate: calendarBloc.state.selectedDay
          ).show();
        },
      ),

      body: LayoutBuilder(
        builder: (_, constraints){
          
          return AnimatedFloatingActionButtonScrollNotification(
            currentState: showFloatingActionButton,
            onChange: (value) => setState(() => showFloatingActionButton = value),

            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              slivers: [

                SliverAppBar(
                  backgroundColor: customTheme.backgroundColor,
                  collapsedHeight: appBarHeight,
                  flexibleSpace: WidgetSize(
                    onChange: (Size size){
                      setState(() => appBarHeight = size.height);
                      context.read<AvailableSpaceCubit>().setHeight(
                        constraints.maxHeight - size.height - contentHeight
                      );
                    },
                    child: MyAppBar(
                      header: context.l10n.calendarScreen_title,
                      description: context.l10n.calendarScreen_description
                    )
                  )
                ),

                SliverToBoxAdapter(
                  child: BlocBuilder<CalendarBloc, CalendarState>(
                    builder: (_, calendarState) {
                      final items = calendarState.items;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          WidgetSize(
                            onChange: (Size size){
                              setState(() => contentHeight = size.height);
                              context.read<AvailableSpaceCubit>().setHeight(
                                constraints.maxHeight - appBarHeight - size.height
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: cPadding),
                                  child: CalendarMonthPicker(
                                    months: calendarState.months,
                                    initialMonth: DateTime.now(),
                                    onChanged: (date) => calendarBloc.add(CalendarSelectedMonthChanged(date))
                                  ),
                                ),

                                const SizedBox(height: 8.0),

                                NotificationListener<ScrollEndNotification>(
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    scrollDirection: Axis.horizontal,
                                    padding: tabWidth != null ? EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width / 2 - tabWidth! / 2
                                    ) : null,
                                    physics: tabWidth != null ? SnapBounceScrollPhysics(
                                      itemWidth: tabWidth!
                                    ) : const BouncingScrollPhysics(),

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
                                            isSelected: day == calendarState.selectedDay,
                                            onTap: () => calendarBloc.add(CalendarSelectedDayChanged(day))
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  onNotification: (notification){
                                    if(tabWidth != null){
                                      final day = calendarState.days[scrollController.position.pixels ~/ tabWidth!];
                                      if(day != calendarBloc.state.selectedDay){
                                        calendarBloc.add(CalendarSelectedDayChanged(day));
                                      }
                                    }
                                    return true;
                                  }
                                ),

                                const SizedBox(height: cPadding - cListItemSpace),
                              ],
                            ),
                          ),

                          !calendarState.isLoading ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: cPadding),
                            child: AlignedAnimatedSwitcher(
                              alignment: Alignment.topCenter,
                              child: items.isNotEmpty ? AnimatedDynamicTaskList(
                                items: items,
                                taskListItemType: TaskListItemType.calendar,
                                buildContext: context,
                                onUndoDismissed: (task) => context.read<TaskBloc>().add(TaskUndoDeleted(task)),
                                objectBuilder: (object){
                                  return (object is DateTime) ? CalendarGroupHour(dateTime: object) : Container();
                                }
                              ) : FillRemainingList(
                                availableSpaceCubit: context.read<AvailableSpaceCubit>(),
                                child: EmptySpace(
                                  svgImage: "assets/svg/completed_tasks.svg",
                                  header: context.l10n.emptySpace_youHaventTasksOnThisDay,
                                  description: context.l10n.emptySpace_youHaventTasksOnThisDay_description,
                                )
                              ),
                            )
                          ) : const Padding(
                            padding: EdgeInsets.only(top: cPadding),
                            child: ShimmerList(
                              minItems: 3,
                              maxItems: 4,
                              child: CalendarTaskListItem(isShimmer: true)
                            ),
                          ),

                          const SizedBox(height: cPadding),
                        ],
                      );
                    }
                  ),
                ),
              ]
            ),
          );
        },
      ),
    );
  }
}