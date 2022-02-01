import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/models/sync_object.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/sync_repository.dart';
import 'package:collection/collection.dart';

part 'sync_event.dart';
part 'sync_state.dart';

enum SyncPushStatus { idle, pending }

class SyncBloc extends Bloc<SyncEvent, SyncState> {

  final SyncRepository syncRepository;

  final TaskBloc taskBloc;
  late StreamSubscription taskBlocSubscription;
  
  SyncBloc({
    required this.syncRepository,
    required this.taskBloc
  }) : super(SyncState()){

    taskBlocSubscription = taskBloc.stream.listen((taskState){
      if(taskState is TaskLoadSuccess && taskState.syncPushStatus == SyncPushStatus.pending){
        add(SyncPushRequested(syncObject: SyncObject.task(items: taskState.tasks)));
      }
    });

    on<SyncPushRequested>((event, emit) async{
      /*final eventId = Uuid().v4();
      print("$eventId | SyncPush requested");
      print("$eventId | Enviando peticion a la API...");
      await Future.delayed(Duration(seconds: 2));*/

      event.syncObject.when(
        task: (tasks) async{

          final updatedTasks = _itemsUpdatedAfterDate<Task>(date: null, items: tasks);
          if(updatedTasks == null) return;

          final responseItems = await syncRepository.push<Task>(
            queryPath: "tasks",
            items: updatedTasks
          );
          //print("$eventId | Respuesta de la API recibida...");

          if(responseItems != null){
            final taskState = taskBloc.state;
            if(taskState is TaskLoadSuccess) taskBloc.add(TaskStateUpdated(taskState.copyWith(
              syncPushStatus: SyncPushStatus.idle,
              tasks: _replaceItems<Task>(items: taskState.tasks, replace: responseItems)
            )));
          }
        },
        category: (categories){

        }
      );
    },
    transformer: (events, mapper){
      return events.debounceTime(Duration(seconds: 3)).switchMap(mapper);
    });
  }

  List<T>? _itemsUpdatedAfterDate<T>({
    required DateTime? date,
    required List<dynamic> items
  }){
    try{
      if(date != null) return List<T>.from(items.where((i) => i.updatedAt.isAfter(date)));
      return List<T>.from(items);
    }
    catch(_){}
  }

  List<T>? _replaceItems<T>({
    required List<dynamic> items,
    required List<dynamic> replace
  }){
    try{
      return List<T>.from(items.map((i){
        final r = replace.firstWhereOrNull((r) => r.id == i.id);
        if(r != null) replace.remove(r);
        return r ?? i;
      }));
    }
    catch(_){}
  }

  @override
  Future<void> close() {
    taskBlocSubscription.cancel();
    return super.close();
  }
}