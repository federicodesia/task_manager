import 'package:declarative_animated_list/declarative_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/task_bottom_sheet.dart';
import 'package:task_manager/components/calendar/calendar_task_list_item.dart';
import 'package:task_manager/components/lists/rounded_dismissible.dart';
import 'package:task_manager/components/lists/task_list_item.dart';
import 'package:task_manager/models/tab.dart';
import 'package:task_manager/models/task.dart';

import '../../constants.dart';
import '../rounded_snack_bar.dart';
import 'list_header.dart';

class AnimatedTaskList extends StatelessWidget{
  final String? headerTitle;
  final List<Task> items;
  final BuildContext context;
  final Function(Task) onUndoDismissed;

  AnimatedTaskList({
    this.headerTitle,
    required this.items,
    required this.context,
    required this.onUndoDismissed
  });

  @override
  Widget build(BuildContext buildContext){
    return Column(
      children: [
        if(headerTitle != null) AnimatedSwitcher(
          duration: cAnimatedListDuration,
          transitionBuilder: (widget, animation){
            return BuildAnimation(
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
            return BuildAnimation(
              animation: animation,
              child: BuildItemList(
                task: task,
                animation: animation,
                context: context,
                onUndoDismissed: onUndoDismissed,
              ),
            );
          },
          removeBuilder: (BuildContext context, Task task, int index, Animation<double> animation){
            return BlocBuilder<TaskBloc, TaskState>(
              builder: (_, state){
                return (state as TaskLoadSuccess).tasks.where((t) => t.uuid == task.uuid).isNotEmpty ?
                  BuildAnimation(
                    animation: animation,
                    child: BuildItemList(
                      task: task,
                      animation: animation,
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

class BuildAnimation extends StatelessWidget{
  final Animation<double> animation;
  final Widget child;

  BuildAnimation({
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

class BuildItemList extends StatelessWidget{
  final Task task;
  final Animation<double> animation;
  final BuildContext context;
  final Function(Task) onUndoDismissed;

  BuildItemList({
    required this.task,
    required this.animation,
    required this.context,
    required this.onUndoDismissed
  });

  @override
  Widget build(BuildContext buildContext) {

    return Padding(
      padding: EdgeInsets.only(bottom: cListItemSpace),
      child: RoundedDismissible(
        key: UniqueKey(),
        text: "Delete task",
        icon: Icons.delete_rounded,
        color: cRedColor,
        child: CalendarTaskListItem(
          task: task,
          onPressed: (){
            ModalBottomSheet(
              title: tabList[0].editTitle,
              context: context,
              content: TaskBottomSheet(editTask: task)
            ).show();
          },
          onChanged: (value) {
            BlocProvider.of<TaskBloc>(context).add(
              TaskCompleted(
                task: task,
                value: value!
              )
            );
          },
        ),
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