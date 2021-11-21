import 'package:declarative_animated_list/declarative_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/task_bottom_sheet.dart';
import 'package:task_manager/components/calendar/calendar_task_list_item.dart';
import 'package:task_manager/components/lists/rounded_dismissible.dart';
import 'package:task_manager/components/lists/checkbox_task_list_item.dart';
import 'package:task_manager/models/tab.dart';
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
            return TaskListItemAnimation(
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
            return TaskListItemAnimation(
              animation: animation,
              child: TaskListItem(
                task: task,
                type: type,
                context: context,
                onUndoDismissed: onUndoDismissed,
              ),
            );
          },
          removeBuilder: (BuildContext context, Task task, int index, Animation<double> animation){
            return BlocBuilder<TaskBloc, TaskState>(
              builder: (_, state){
                return (state as TaskLoadSuccess).tasks.where((t) => t.uuid == task.uuid).isNotEmpty ?
                  TaskListItemAnimation(
                    animation: animation,
                    child: TaskListItem(
                      task: task,
                      type: type,
                      context: context,
                      onUndoDismissed: onUndoDismissed,
                    ),
                  )
                : Container();
              }
            );
          },
        ),
      ],
    );
  }
}

class TaskListItemAnimation extends StatelessWidget{
  final Animation<double> animation;
  final Widget child;

  TaskListItemAnimation({
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Interval(0.75, 1.0, curve: Curves.easeInOut),
        ),
      ),
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn
        ),
        child: child,
      )
    );
  }
}

class TaskListItem extends StatelessWidget{
  final Task task;
  final TaskListItemType type;
  final BuildContext context;
  final Function(Task) onUndoDismissed;

  TaskListItem({
    required this.task,
    required this.type,
    required this.context,
    required this.onUndoDismissed
  });

  @override
  Widget build(BuildContext _) {

    final Function() onPressed = ModalBottomSheet(
      title: tabList[0].editTitle,
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
      padding: EdgeInsets.only(bottom: cListItemSpace),
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