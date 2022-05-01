import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/blocs/upcoming_bloc/upcoming_bloc.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/components/charts/week_bar_chat.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/lists/animated_dynamic_task_list.dart';
import 'package:task_manager/components/lists/checkbox_task_list_item.dart';
import 'package:task_manager/components/lists/list_header.dart';
import 'package:task_manager/components/lists/task_list_item.dart';
import 'package:task_manager/components/responsive/fill_remaining_list.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/shimmer/shimmer_list.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/l10n/l10n.dart';

class UpcomingTab extends StatelessWidget{
  
  final AvailableSpaceCubit availableSpaceCubit;

  const UpcomingTab({
    Key? key,
    required this.availableSpaceCubit
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpcomingBloc(taskBloc: context.read<TaskBloc>()),
      child: _UpcomingTab(availableSpaceCubit: availableSpaceCubit),
    );
  }
}

class _UpcomingTab extends StatefulWidget{
  
  final AvailableSpaceCubit availableSpaceCubit;
  const _UpcomingTab({required this.availableSpaceCubit});

  @override
  _UpcomingTabState createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<_UpcomingTab>{

  late Widget child;
  double weekBarChartHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<UpcomingBloc, UpcomingState>(
      builder: (context, state){

        if(state is UpcomingLoadSuccess){

          final weekTasks = state.weekTasks;
          final items = state.items;

          if(weekTasks.isEmpty && items.isEmpty){
            child = FillRemainingList(
              availableSpaceCubit: widget.availableSpaceCubit,
              child: EmptySpace(
                svgImage: "assets/svg/completed_tasks.svg",
                header: context.l10n.emptySpace_youHaventTasksForLater,
                description: context.l10n.emptySpace_youHaventTasksForLater_description,
              ),
            );
          }
          else{
            child = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if(weekTasks.isNotEmpty) WidgetSize(
                  onChange: (Size size){
                    setState(() => weekBarChartHeight = size.height);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: WeekBarChart(
                      header: context.l10n.upcomingTab_tasksInThisWeek,
                      weekCompletedTasksCount: state.weekCompletedTasksCount,
                      weekRemainingTasksCount: state.weekRemainingTasksCount,
                      weekTasks: state.weekTasks,
                      weekCompletedTasks: state.weekCompletedTasks
                    ),
                  ),
                ),

                if(items.isNotEmpty) AnimatedDynamicTaskList(
                  items: items,
                  taskListItemType: TaskListItemType.checkbox,
                  buildContext: context,
                  onUndoDismissed: (task) => context.read<TaskBloc>().add(TaskUndoDeleted(task)),
                  objectBuilder: (object){
                    if(object is DateTime){
                      final DateTime dateTime = object;
                      return ListHeader(dateTime.humanFormat(context));
                    }
                    return Container();
                  }
                )
                else FillRemainingList(
                  availableSpaceCubit: widget.availableSpaceCubit,
                  subtractHeight: weekBarChartHeight,
                  child: EmptySpace(
                    header: context.l10n.emptySpace_youHaventTasksForLater,
                    description: context.l10n.emptySpace_youHaventTasksForLater_description,
                  ),
                )
              ],
            );
          }
        }
        else{
          child = const ShimmerList(
            minItems: 2,
            maxItems: 4,
            child: CheckboxTaskListItem(isShimmer: true)
          );
        }

        return AlignedAnimatedSwitcher(
          child: child,
        );
      }
    );
  }
}