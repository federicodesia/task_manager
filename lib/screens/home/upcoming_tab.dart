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
import 'package:task_manager/models/dynamic_object.dart';
import 'package:task_manager/models/task.dart';

class UpcomingTab extends StatelessWidget{
  
  final AvailableSpaceCubit availableSpaceCubit;
  UpcomingTab({required this.availableSpaceCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpcomingBloc(taskBloc: context.read<TaskBloc>())..add(UpcomingLoaded()),
      child: _UpcomingTab(availableSpaceCubit: availableSpaceCubit),
    );
  }
}

class _UpcomingTab extends StatefulWidget{
  
  final AvailableSpaceCubit availableSpaceCubit;
  _UpcomingTab({required this.availableSpaceCubit});

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

          List<Task> weekTasksList = state.weekTasks;
          List<DynamicObject> items = state.items;

          if(weekTasksList.isEmpty && items.isEmpty){
            child = FillRemainingList(
              availableSpaceCubit: widget.availableSpaceCubit,
              child: EmptySpace(
                svgImage: "assets/svg/completed_tasks.svg",
                svgHeight: MediaQuery.of(context).orientation == Orientation.portrait ? 
                          MediaQuery.of(context).size.width * 0.4 :
                          MediaQuery.of(context).size.height * 0.4,
                header: context.l10n.emptySpace_youHaventTasksForLater,
                description: context.l10n.emptySpace_youHaventTasksForLater_description,
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
                      header: context.l10n.upcomingTab_tasksInThisWeek,
                      weekTasksList: weekTasksList,
                    ),
                  ),
                ),

                if(items.isNotEmpty) AnimatedDynamicTaskList(
                  items: items,
                  taskListItemType: TaskListItemType.Checkbox,
                  context: context,
                  onUndoDismissed: (task) => BlocProvider.of<TaskBloc>(context).add(TaskUndoDeleted(task)),
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
          child = ShimmerList(
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