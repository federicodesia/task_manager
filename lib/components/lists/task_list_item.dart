import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/task_bottom_sheet.dart';
import 'package:task_manager/components/calendar/calendar_task_list_item.dart';
import 'package:task_manager/components/lists/rounded_dismissible.dart';
import 'package:task_manager/components/lists/checkbox_task_list_item.dart';
import 'package:task_manager/models/task.dart';

import '../../constants.dart';
import '../rounded_snack_bar.dart';

enum TaskListItemType{
  Checkbox,
  Calendar
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
    required this.onUndoDismissed,
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