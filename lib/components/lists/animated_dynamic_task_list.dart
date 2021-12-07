import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/components/lists/declarative_animated_list.dart';
import 'package:task_manager/components/lists/list_item_animation.dart';
import 'package:task_manager/components/lists/task_list_item.dart';
import 'package:task_manager/models/dynamic_object.dart';
import 'package:task_manager/models/task.dart';

class AnimatedDynamicTaskList extends StatelessWidget{
  final List<DynamicObject> items;
  final TaskListItemType taskListItemType;
  final Widget Function(Object) objectBuilder;
  final BuildContext context;
  final Function(Task) onUndoDismissed;

  AnimatedDynamicTaskList({
    required this.items,
    required this.taskListItemType,
    required this.objectBuilder,
    required this.context,
    required this.onUndoDismissed
  });

  @override
  Widget build(BuildContext _){

    return DeclarativeAnimatedList(
      items: items,
      equalityCheck: (DynamicObject a, DynamicObject b) => a.object == b.object,
      itemBuilder: (BuildContext context, DynamicObject dynamicObject, int index, Animation<double> animation){
        final dynamic item = dynamicObject.object;

        return ListItemAnimation(
          animation: animation,
          child: item is Task ? TaskListItem(
            task: item,
            type: taskListItemType,
            context: context,
            onUndoDismissed: onUndoDismissed
          ) : objectBuilder(item)
        );
      },
      removeBuilder: (BuildContext context, DynamicObject dynamicObject, int index, Animation<double> animation){
        final dynamic item = dynamicObject.object;
        
        return ListItemAnimation(
          animation: animation,
          child: item is Task ? BlocBuilder<TaskBloc, TaskState>(
            builder: (_, state){
              if(state is TaskLoadSuccess){
                return state.tasks.where((t) => t.uuid == item.uuid).isNotEmpty ?
                  TaskListItem(
                    task: item,
                    type: taskListItemType,
                    context: context,
                    onUndoDismissed: onUndoDismissed
                  )
                : Container();
              }
              return Container();
            }
          ) : objectBuilder(item)
        );
      },
    );
  }
}