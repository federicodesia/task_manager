import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/task_bottom_sheet.dart';
import 'package:task_manager/components/lists/list_header.dart';
import 'package:task_manager/components/lists/rounded_dismissible.dart';
import 'package:task_manager/components/lists/task_list_item.dart';
import 'package:task_manager/components/rounded_snack_bar.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/tabs/tabs.dart';

class TodayTab extends StatefulWidget{

  @override
  _TodayTabState createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab>{
  
  bool isToday(DateTime dateTime){
    return DateTime.now().difference(dateTime).inDays == 0;
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state){

        if(state is TaskLoadSuccess){
          if(state.tasks.isEmpty){
            return Center(child: Text("No content"));
          }

          List<Task> todayTasks = List.from(state.tasks.where((task) => !task.completed && isToday(task.dateTime)));
          List<Task> completedTasks = List.from(state.tasks.where((task) => task.completed && isToday(task.dateTime)));

          return ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: cPadding),
            children: [
              todayTasks.length > 0 ? ListHeader("Tasks") : Container(),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: todayTasks.length,
                itemBuilder: (context, index){
                  return buildItem(todayTasks[index], context, index);
                }
              ),

              completedTasks.length > 0 ? ListHeader("Completed") : Container(),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: completedTasks.length,
                itemBuilder: (context, index){
                  return buildItem(completedTasks[index], context, index);
                }
              ),
            ],
          );
        }

        return Center(child: CircularProgressIndicator());
      }
    );
  }
}

Widget buildItem(Task task, BuildContext context, int index){
  return Padding(
    padding: EdgeInsets.only(bottom: cListItemSpace),
    child: RoundedDismissible(
      key: ValueKey<Task>(task),
      text: "Delete task",
      icon: Icons.delete_rounded,
      color: cRedColor,
      child: TaskListItem(
        task: task,
        onPressed: (){
          ModalBottomSheet(
            title: tabList[0].editTitle,
            context: context,
            content: TaskBottomSheet(editTask: task)
          ).show();
        },
        onChanged: (value) {
          BlocProvider.of<TaskBloc>(context).add(TaskCompleted(task: task, value: value));
        },
      ),
      onDismissed: (direction) {
        Task tempTask = task;
        BlocProvider.of<TaskBloc>(context).add(TaskDeleted(task));

        RoundedSnackBar(
          context: context,
          text: "Task deleted",
          action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              BlocProvider.of<TaskBloc>(context).add(TaskUndoDeleted(tempTask, index));
            },
          )
        ).show();
      },
    ),
  );
}