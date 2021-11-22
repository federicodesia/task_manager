import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/components/lists/animated_task_list.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/tasks_group_hour.dart';

class CalendarGroupHour extends StatelessWidget{

  final TaskGroupHour group;
  final BuildContext context;

  CalendarGroupHour({
    required this.group,
    required this.context
  });

  @override
  Widget build(BuildContext _) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Text(
                DateFormat("HH:00").format(group.hour).toLowerCase(),
                style: cLightTextStyle.copyWith(fontWeight: FontWeight.w300),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              Opacity(
                opacity: 0,
                child: Text(
                  "12:00 ",
                  style: cLightTextStyle.copyWith(fontWeight: FontWeight.w300),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),

          SizedBox(width: 12.0),

          Expanded(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Divider
                    Container(
                      height: 1,
                      color: Colors.white.withOpacity(0.08),
                    ),

                    Opacity(
                      opacity: 0,
                      child: Text("a", style: cLightTextStyle),
                    )
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(top: group.tasks.isNotEmpty ? 4.0 : 0.0),
                  child: AnimatedTaskList(
                    items: group.tasks,
                    type: TaskListItemType.Calendar,
                    context: context,
                    onUndoDismissed: (task) => BlocProvider.of<TaskBloc>(context).add(TaskAdded(task))
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}