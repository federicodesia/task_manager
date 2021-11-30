import 'package:declarative_animated_list/declarative_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/task_bottom_sheet.dart';
import 'package:task_manager/components/calendar/calendar_task_list_item.dart';
import 'package:task_manager/components/lists/list_item_animation.dart';
import 'package:task_manager/components/lists/rounded_dismissible.dart';
import 'package:task_manager/components/lists/checkbox_task_list_item.dart';
import 'package:task_manager/models/task.dart';

import '../../constants.dart';
import '../rounded_snack_bar.dart';
import 'list_header.dart';

enum TaskListItemType{
  Checkbox,
  Calendar
}

class AnimatedTaskList extends StatelessWidget{
  final String? headerTitle;
  final TaskListItemType type;
  final List<Task> items;
  final BuildContext context;
  final Function(Task) onUndoDismissed;

  AnimatedTaskList({
    this.headerTitle,
    required this.type,
    required this.items,
    required this.context,
    required this.onUndoDismissed
  });

  @override
  Widget build(BuildContext _){

    return Column(
      children: [
        if(headerTitle != null) AnimatedSwitcher(
          duration: cAnimatedListDuration,
          transitionBuilder: (widget, animation){
            return ListItemAnimation(
              animation: animation,
              child: widget,
            );
          },
          child: items.length > 0 ? ListHeader(headerTitle!) : Container(),
        ) ,

        DeclarativeList(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          items: items,
          insertDuration: cAnimatedListDuration,
          removeDuration: cAnimatedListDuration,
          equalityCheck: (Task a, Task b) => (a.uuid == b.uuid),
          itemBuilder: (BuildContext context, Task task, int index, Animation<double> animation){
            return ListItemAnimation(
              animation: animation,
              child: TaskListItem(
                task: task,
                type: type,
                context: context,
                onUndoDismissed: onUndoDismissed,
                bottomPadding: index != items.length - 1,
              ),
            );
          },
          removeBuilder: (BuildContext context, Task task, int index, Animation<double> animation){
            return BlocBuilder<TaskBloc, TaskState>(
              builder: (_, state){
                if(state is TaskLoadSuccess){
                  return state.tasks.where((t) => t.uuid == task.uuid).isNotEmpty ?
                    ListItemAnimation(
                      animation: animation,
                      child: TaskListItem(
                        task: task,
                        type: type,
                        context: context,
                        onUndoDismissed: onUndoDismissed,
                        bottomPadding: index != items.length - 1,
                      ),
                    )
                  : Container();
                }
                return Container();
              }
            );
          },
        ),
      ],
    );
  }
}

class TaskListItem extends StatelessWidget{
  final Task task;
  final TaskListItemType type;
  final BuildContext context;
  final Function(Task) onUndoDismissed;
  final bool bottomPadding;

  TaskListItem({
    required this.task,
    required this.type,
    required this.context,
    required this.onUndoDismissed,
    required this.bottomPadding
  });

  @override
  Widget build(BuildContext _) {

    final Function() onPressed = ModalBottomSheet(
      title: "Edit task",
      context: context,
      content: TaskBottomSheet(editTask: task)
    ).show;

    final Widget item;
    switch(type){
      case TaskListItemType.Calendar:
        item = CalendarTaskListItem(
          task: task,
          onPressed: onPressed,
        );
        break;
      
      case TaskListItemType.Checkbox:
        item = CheckboxTaskListItem(
          task: task,
          onPressed: onPressed,
          onChanged: (value) => BlocProvider.of<TaskBloc>(context).add(
            TaskCompleted(task: task, value: value!)
          ),
        );
        break;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ? cListItemSpace : 0.0),
      child: RoundedDismissible(
        key: UniqueKey(),
        text: "Delete task",
        icon: Icons.delete_rounded,
        color: cRedColor,
        child: item,
        onDismissed: (_) {
          Task tempTask = task;
          BlocProvider.of<TaskBloc>(context).add(TaskDeleted(task));

          RoundedSnackBar(
            context: context,
            text: "Task deleted",
            action: SnackBarAction(
              label: "Undo",
              onPressed: () => onUndoDismissed(tempTask)
            )
          ).show();
        },
      ),
    );
  }
}