import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:task_manager/blocs/sync_bloc/events/dynamic_functions.dart';
import 'package:task_manager/blocs/sync_bloc/sync_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/models/sync_status.dart';
import 'package:task_manager/models/task.dart';

void onPushTaskRequested(
  SyncBloc bloc,
  SyncPushTaskRequested event,
  Emitter<SyncState> emit
) async{

  print("PushTask requested");
  final tempDate = DateTime.now();

  final updatedTasks = itemsUpdatedAfterDate<Task>(
    date: bloc.state.lastTaskPush,
    items: event.tasks,
    failedItems: event.failedTasks
  );
  if(updatedTasks == null) return;

  print("PushTask | Enviando peticion a la API...");
  await Future.delayed(Duration(seconds: 2));
  final responseItems = await bloc.syncRepository.push<Task>(
    queryPath: "tasks",
    items: updatedTasks
  );
  print("PushTask | Respuesta de la API recibida...");

  final taskBloc = bloc.taskBloc;
  final taskState = taskBloc.state;
  if(taskState is! TaskLoadSuccess) return;

  if(responseItems != null) responseItems.when(
    left: (duplicatedId) {
      final mergedDuplicatedId = mergeDuplicatedId<Task>(
        items: taskState.tasks,
        failedItems: taskState.failedTasks,
        duplicatedId: duplicatedId
      );
      if(mergedDuplicatedId == null) return;

      taskBloc.add(TaskStateUpdated(taskState.copyWith(
        syncPushStatus: SyncStatus.pending,
        tasks: mergedDuplicatedId.item1,
        failedTasks: mergedDuplicatedId.item2
      )));
    },
    right: (items){
      final mergedTasks = mergeItems<Task>(
        date: tempDate,
        currentItems: taskState.tasks,
        currentDeletedItems: taskState.deletedTasks,
        replaceItems: items
      );
      if(mergedTasks == null) return;

      taskBloc.add(TaskStateUpdated(taskState.copyWith(
        syncPushStatus: SyncStatus.idle,
        tasks: mergedTasks.item1,
        deletedTasks: mergedTasks.item2,
        failedTasks: removeDuplicatedId(
          failedItems: taskState.failedTasks,
          replaceItems: items
        )
      )));

      emit(bloc.state.copyWith(lastTaskPush: tempDate));
    }
  );
}