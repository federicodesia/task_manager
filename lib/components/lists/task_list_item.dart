import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/bottom_sheets/task_bottom_sheet.dart';
import 'package:task_manager/components/calendar/calendar_task_list_item.dart';
import 'package:task_manager/components/lists/rounded_dismissible.dart';
import 'package:task_manager/components/lists/checkbox_task_list_item.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/task.dart';

import '../../constants.dart';
import '../rounded_snack_bar.dart';

enum TaskListItemType{
  checkbox,
  calendar
}

class TaskListItem extends StatelessWidget{
  final Task task;
  final TaskListItemType type;
  final BuildContext buildContext;
  final Function(Task) onUndoDismissed;

  const TaskListItem({
    Key? key, 
    required this.task,
    required this.type,
    required this.buildContext,
    required this.onUndoDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Function() onPressed = TaskBottomSheet(
      buildContext,
      editTask: task
    ).show;

    final Widget item;
    switch(type){
      case TaskListItemType.calendar:
        item = CalendarTaskListItem(
          task: task,
          onPressed: onPressed,
        );
        break;
      
      case TaskListItemType.checkbox:
        item = CheckboxTaskListItem(
          task: task,
          onPressed: onPressed,
          onChanged: (value) => buildContext.read<TaskBloc>().add(
            TaskUpdated(task.copyWith(isCompleted: value))
          ),
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: cListItemSpace),
      child: RoundedDismissible(
        text: buildContext.l10n.dismissible_deleteTask,
        icon: Icons.delete_rounded,
        color: cRedColor,
        child: item,
        onDismissed: (_) {
          Task tempTask = task;
          buildContext.read<TaskBloc>().add(TaskDeleted(task));

          RoundedSnackBar(
            context: buildContext,
            text: buildContext.l10n.snackBar_taskDeleted,
            action: SnackBarAction(
              label: buildContext.l10n.snackBar_undo,
              textColor: cPrimaryColor,
              onPressed: () => onUndoDismissed(tempTask)
            )
          ).show();
        },
      ),
    );
  }
}