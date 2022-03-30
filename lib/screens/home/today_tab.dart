import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/components/cards/progress_summary.dart';
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

class TodayTab extends StatefulWidget{

  final AvailableSpaceCubit availableSpaceCubit;

  const TodayTab({
    Key? key,
    required this.availableSpaceCubit
  }) : super(key: key);

  @override
  _TodayTabState createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab>{

  late Widget child;
  double progressSummaryHeight = 0.0;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (_, state){

        if(!state.isLoading){
          List<Task> tasksList = state.tasks;

          if(tasksList.isEmpty){
            child = FillRemainingList(
              availableSpaceCubit: widget.availableSpaceCubit,
              child: EmptySpace(
                svgImage: "assets/svg/completed_tasks.svg",
                header: context.l10n.emptySpace_createYourFirstTask,
                description: context.l10n.emptySpace_createYourFirstTask_description,
              ),
            );
          }
          else{
            List<Task> todayTasks = tasksList.where((task) => task.date.differenceInDays(DateTime.now()) == 0).toList();
            List<Task> remainingTasks = todayTasks.where((task) => !task.isCompleted).toList();
            List<Task> completedTasks = todayTasks.where((task) => task.isCompleted).toList();

            List<DynamicObject> items = [];

            if(remainingTasks.isNotEmpty){
              items.add(DynamicObject(object: context.l10n.tasks));
              items.addAll(remainingTasks.map((task) => DynamicObject(object: task)));
            }

            if(completedTasks.isNotEmpty){
              items.add(DynamicObject(object: context.l10n.enum_taskFilter_completed));
              items.addAll(completedTasks.map((task) => DynamicObject(object: task)));
            }

            child = Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WidgetSize(
                  onChange: (Size size){
                    setState(() => progressSummaryHeight = size.height);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ProgressSummary(
                      header: context.l10n.progressSummary_title,
                      completed: completedTasks.length,
                      total: todayTasks.length,
                    ),
                  ),
                ),

                if(todayTasks.isNotEmpty) AnimatedDynamicTaskList(
                  items: items,
                  taskListItemType: TaskListItemType.checkbox,
                  buildContext: context,
                  onUndoDismissed: (task) => context.read<TaskBloc>().add(TaskUndoDeleted(task)),
                  objectBuilder: (object){
                    return (object is String) ? ListHeader(object) : Container();
                  }
                )
                else FillRemainingList(
                  availableSpaceCubit: widget.availableSpaceCubit,
                  subtractHeight: progressSummaryHeight,
                  child: EmptySpace(
                    header: context.l10n.emptySpace_youHaventTasksToday,
                    description: context.l10n.emptySpace_youHaventTasksToday_description,
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