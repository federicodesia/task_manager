import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/sync_bloc/sync_service.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/models/serializers/datetime_serializer.dart';
import 'package:task_manager/models/sync_status.dart';
import 'package:task_manager/repositories/sync_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

part 'sync_event.dart';
part 'sync_state.dart';

part 'sync_bloc.g.dart';

class SyncBloc extends HydratedBloc<SyncEvent, SyncState> {

  final SyncRepository syncRepository;
  final TaskBloc taskBloc;
  final CategoryBloc categoryBloc;

  late StreamSubscription taskBlocSubscription;
  late StreamSubscription categoryBlocSubscription;
  
  SyncBloc({
    required this.syncRepository,
    required this.taskBloc,
    required this.categoryBloc
  }) : super(SyncState()){

    taskBlocSubscription = taskBloc.stream.listen((taskState){
      if(taskState is TaskLoadSuccess && taskState.syncPushStatus == SyncStatus.pending){
        add(SyncRequested());
      }
    });

    categoryBlocSubscription = categoryBloc.stream.listen((categoryState){
      if(categoryState is CategoryLoadSuccess && categoryState.syncPushStatus == SyncStatus.pending){
        add(SyncRequested());
      }
    });

    on<SyncRequested>((event, emit) async{
      final syncService = SyncService();

      await syncService.sync(
        lastSync: state.lastSync,
        syncRepository: syncRepository,

        onGetTasks: () {
          final taskState = taskBloc.state;
          if(taskState is TaskLoadSuccess) return Tuple3(
            taskState.tasks,
            taskState.deletedTasks,
            taskState.failedTasks
          );
        },

        onGetCategories: () {
          final categoryState = categoryBloc.state;
          if(categoryState is CategoryLoadSuccess) return Tuple3(
            categoryState.categories,
            categoryState.deletedCategories,
            categoryState.failedCategories
          );
        },

        onMergeTasks: (syncStatus, mergedTasks){
          final taskState = taskBloc.state;
          if(taskState is TaskLoadSuccess) taskBloc.add(TaskStateUpdated(taskState.copyWith(
            syncPushStatus: syncStatus,
            tasks: mergedTasks.item1,
            deletedTasks: mergedTasks.item2,
            failedTasks: mergedTasks.item3
          )));
        },

        onMergeCategories: (syncStatus, mergedCategories){
          final categoryState = categoryBloc.state;
          if(categoryState is CategoryLoadSuccess) categoryBloc.add(CategoryStateUpdated(categoryState.copyWith(
            syncPushStatus: syncStatus,
            categories: mergedCategories.item1,
            deletedCategories: mergedCategories.item2,
            failedCategories: mergedCategories.item3
          )));
        },
      ).then((lastSync){
        if(lastSync != null) emit(state.copyWith(lastSync: lastSync));
      });
    },
    transformer: (events, mapper) {
      return events.debounceTime(const Duration(seconds: 5)).switchMap(mapper);
    });
  }

  @override
  Future<void> close() {
    taskBlocSubscription.cancel();
    categoryBlocSubscription.cancel();
    return super.close();
  }

  @override
  SyncState? fromJson(Map<String, dynamic> json) {
    try{
      return SyncState.fromJson(json);
    }
    catch(error) {}
  }

  @override
  Map<String, dynamic>? toJson(SyncState state) {
    try{
      return state.toJson();
    }
    catch(error) {}
  }
}