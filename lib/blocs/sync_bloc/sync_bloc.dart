import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/sync_item_error.dart';
import 'package:task_manager/models/sync_object.dart';
import 'package:task_manager/models/sync_status.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/sync_repository.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

part 'sync_event.dart';
part 'sync_state.dart';

part 'sync_bloc.g.dart';

class SyncBloc extends HydratedBloc<SyncEvent, SyncState> {

  final SyncRepository syncRepository;
  final TaskBloc taskBloc;
  late StreamSubscription taskBlocSubscription;
  
  SyncBloc({
    required this.syncRepository,
    required this.taskBloc
  }) : super(SyncState()){

    taskBlocSubscription = taskBloc.stream.listen((taskState){
      if(taskState is TaskLoadSuccess && taskState.syncPushStatus == SyncStatus.pending){
        add(SyncPushRequested(syncObject: SyncObject.task(
          items: taskState.tasks + taskState.deletedTasks,
          failedItems: taskState.failedTasks
        )));
      }
    });

    on<SyncPushRequested>((event, emit) async{
      final eventId = Uuid().v4();
      print("$eventId | SyncPush requested");

      final tempDate = DateTime.now();

      await event.syncObject.when(
        task: (tasks, failedTasks) async{

          final updatedTasks = _itemsUpdatedAfterDate<Task>(
            date: state.lastTaskPush,
            items: tasks,
            failedItems: failedTasks
          );
          if(updatedTasks == null) return;

          print("$eventId | Enviando peticion a la API...");
          await Future.delayed(Duration(seconds: 2));
          final responseItems = await syncRepository.push<Task>(
            queryPath: "tasks",
            items: updatedTasks
          );
          print("$eventId | Respuesta de la API recibida...");

          final taskState = taskBloc.state;
          if(taskState is! TaskLoadSuccess) return;

          if(responseItems != null) responseItems.when(
            left: (duplicatedId) {
              final mergedDuplicatedId = _mergeDuplicatedId<Task>(
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
              final mergedTasks = _mergeItems<Task>(
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
                failedTasks: _removeDuplicatedId(
                  failedItems: taskState.failedTasks,
                  replaceItems: items
                )
              )));

              emit(state.copyWith(lastTaskPush: tempDate));
            }
          );
        },
        category: (categories, failedCategories){

        }
      );
    },
    transformer: (events, mapper){
      return events.debounceTime(Duration(seconds: 3)).switchMap(mapper);
    });
  }

  Tuple2<List<T>, Map<String, SyncErrorType>>? _mergeDuplicatedId<T>({
    required List<dynamic> items,
    required Map<String, SyncErrorType> failedItems,
    required String duplicatedId
  }){
    try{

      final failedItem = failedItems[duplicatedId];
      if(failedItem != null){
        if(failedItem == SyncErrorType.duplicatedId)
          failedItems[duplicatedId] = SyncErrorType.blacklist;
      }
      else{
        final index = items.lastIndexWhere((i) => i.id == duplicatedId);
        if(index != -1){
          final newId = Uuid().v4();
          failedItems[newId] = SyncErrorType.duplicatedId;
          items[index] = items.elementAt(index).copyWith(id: newId);
        }
      }

      return Tuple2(
        List<T>.from(items),
        failedItems
      );
    }
    catch(_){}
  }

  Map<String, SyncErrorType>? _removeDuplicatedId({
    required Map<String, SyncErrorType> failedItems,
    required List<dynamic> replaceItems,
  }){
    try{
      replaceItems.forEach((item) => failedItems.remove(item.key));
      return failedItems;
    }
    catch(_){}
  }

  List<T>? _itemsUpdatedAfterDate<T>({
    required DateTime? date,
    required List<dynamic> items,
    required Map<String, SyncErrorType> failedItems
  }){
    try{
      if(date != null) items = items..removeWhere((i) => failedItems[i.id] == SyncErrorType.blacklist || !i.updatedAt.isAfter(date));
      else items = items..removeWhere((i) => failedItems[i.id] == SyncErrorType.blacklist);
      return items.isNotEmpty ? List<T>.from(items) : null;
    }
    catch(_){}
  }

  Tuple2<List<T>, List<T>>? _mergeItems<T>({
    required DateTime date,
    required List<dynamic> currentItems,
    required List<dynamic> currentDeletedItems,
    required List<dynamic> replaceItems
  }){
    try{
      final updatedItems = [];
      final deletedItems = [];
      replaceItems.forEach((r) => r.deletedAt != null ? deletedItems.add(r) : updatedItems.add(r));

      currentDeletedItems.removeWhere((c) => !c.deletedAt.isAfter(date) && deletedItems.any((d) => c.id == d.id));
      
      currentItems = currentItems.map((c){
        if(c.updatedAt.isAfter(date)) return c;
        return updatedItems.firstWhereOrNull((u) => u.id == c.id) ?? c;
      }).toList();
      
      return Tuple2(
        List<T>.from(currentItems),
        List<T>.from(currentDeletedItems)
      );
    }
    catch(_){}
  }

  @override
  Future<void> close() {
    taskBlocSubscription.cancel();
    return super.close();
  }

  @override
  SyncState? fromJson(Map<String, dynamic> json) {
    try{return SyncState.fromJson(json);}
    catch(error) {}
  }

  @override
  Map<String, dynamic>? toJson(SyncState state) {
    try{return state.toJson();}
    catch(error) {}
  }
}