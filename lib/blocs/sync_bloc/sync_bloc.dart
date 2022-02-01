import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/sync_object.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/sync_repository.dart';
import 'package:uuid/uuid.dart';

part 'sync_event.dart';
part 'sync_state.dart';

part 'sync_bloc.g.dart';

enum SyncPushStatus { idle, pending }

class SyncBloc extends HydratedBloc<SyncEvent, SyncState> {

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
      final eventId = Uuid().v4();
      print("$eventId | SyncPush requested");

      final tempDate = DateTime.now();

      await event.syncObject.when(
        task: (tasks) async{

          final updatedTasks = _itemsUpdatedAfterDate<Task>(
            date: state.lastTaskPush,
            items: tasks
          );
          if(updatedTasks == null) return;

          print("$eventId | Enviando peticion a la API...");
          await Future.delayed(Duration(seconds: 2));
      
          final responseItems = await syncRepository.push<Task>(
            queryPath: "tasks",
            items: updatedTasks
          );
          if(responseItems == null) return;
          print("$eventId | Respuesta de la API recibida...");

          final taskState = taskBloc.state;
          if(taskState is! TaskLoadSuccess) return;

          taskBloc.add(TaskStateUpdated(taskState.copyWith(
            syncPushStatus: SyncPushStatus.idle,
            tasks: _replaceUnupdatedItems<Task>(
              date: tempDate,
              items: taskState.tasks,
              replace: responseItems
            )
          )));

          emit(state.copyWith(lastTaskPush: tempDate));
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

  List<T>? _replaceUnupdatedItems<T>({
    required DateTime? date,
    required List<dynamic> items,
    required List<dynamic> replace
  }){
    try{
      return List<T>.from(items.map((i){
        if(date != null && i.updatedAt.isAfter(date)) return i;

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