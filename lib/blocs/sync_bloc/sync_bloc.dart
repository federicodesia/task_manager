import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/sync_bloc/events/push_category_requested.dart';
import 'package:task_manager/blocs/sync_bloc/events/push_task_requested.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/serializers/datetime_serializer.dart';
import 'package:task_manager/models/sync_item_error.dart';
import 'package:task_manager/models/sync_status.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/sync_repository.dart';

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
        add(SyncPushTaskRequested(
          tasks: taskState.tasks + taskState.deletedTasks,
          failedTasks: taskState.failedTasks
        ));
      }
    });

    categoryBlocSubscription = categoryBloc.stream.listen((categoryState){
      if(categoryState is CategoryLoadSuccess && categoryState.syncPushStatus == SyncStatus.pending){
        add(SyncPushCategoryRequested(
          categories: categoryState.categories + categoryState.deletedCategories,
          failedCategories: categoryState.failedCategories
        ));
      }
    });

    on<SyncEvent>((_onEvent), transformer: (events, mapper){
      final pushTask = events
        .where((event) => event is SyncPushTaskRequested)
        .debounceTime(Duration(seconds: 5));
      final pushCategory = events
        .where((event) => event is SyncPushCategoryRequested)
        .debounceTime(Duration(seconds: 5));
      
      return MergeStream([pushCategory, pushTask]).asyncExpand(mapper);
    });
  }

  void _onEvent(SyncEvent event, Emitter<SyncState> emit) {
    if(event is SyncPushTaskRequested) return onPushTaskRequested(this, event, emit);
    if(event is SyncPushCategoryRequested) return onPushCategoryRequested(this, event, emit);
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