import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/components/lists/declarative_animated_list.dart';
import 'package:task_manager/components/lists/list_item_animation.dart';
import 'package:task_manager/components/lists/task_list_item.dart';
import 'package:task_manager/models/dynamic_object.dart';
import 'package:task_manager/models/task.dart';
import 'package:collection/collection.dart';

class AnimatedDynamicTaskList extends StatelessWidget{
  final List<DynamicObject> items;
  final TaskListItemType taskListItemType;
  final Widget Function(Object) objectBuilder;
  final BuildContext buildContext;
  final Function(Task) onUndoDismissed;

  const AnimatedDynamicTaskList({
    Key? key, 
    required this.items,
    required this.taskListItemType,
    required this.objectBuilder,
    required this.buildContext,
    required this.onUndoDismissed
  }) : super(key: key);

  @override
  Widget build(BuildContext context){

    return DeclarativeAnimatedList(
      items: items,
      equalityCheck: (DynamicObject a, DynamicObject b) => a.object == b.object,
      itemBuilder: (BuildContext buildContext, DynamicObject dynamicObject, int index, Animation<double> animation){
        final dynamic item = dynamicObject.object;

        return ListItemAnimation(
          animation: animation,
          child: item is Task ? TaskListItem(
            task: item,
            type: taskListItemType,
            buildContext: buildContext,
            onUndoDismissed: onUndoDismissed
          ) : objectBuilder(item)
        );
      },
      removeBuilder: (BuildContext buildContext, DynamicObject dynamicObject, int index, Animation<double> animation){
        final object = dynamicObject.object;

        if(object is Task){
          final taskState = buildContext.read<TaskBloc>().state;
          if(taskState.deletedTasks.firstWhereOrNull((t) => t.id == object.id) != null){
            return Container();
          }
        }
        return null;
      },
    );
  }
}