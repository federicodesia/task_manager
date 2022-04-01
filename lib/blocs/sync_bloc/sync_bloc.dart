import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/blocs/sync_bloc/dynamic_functions.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/blocs/transformers.dart';
import 'package:task_manager/messaging/data_notifications.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/serializers/datetime_serializer.dart';
import 'package:task_manager/models/sync_status.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/sync_repository.dart';

part 'sync_event.dart';
part 'sync_state.dart';

part 'sync_bloc.g.dart';

class SyncBloc extends DriftedBloc<SyncEvent, SyncState> {

  final bool inBackground;
  final AuthBloc authBloc;
  final TaskBloc taskBloc;
  final CategoryBloc categoryBloc;
  final SyncRepository syncRepository;

  late StreamSubscription taskBlocSubscription;
  late StreamSubscription categoryBlocSubscription;

  late StreamSubscription foregroundMessagesSubscription;
  
  SyncBloc({
    required this.inBackground,
    required this.authBloc,
    required this.taskBloc,
    required this.categoryBloc,
    required this.syncRepository,
  }) : super(SyncState.initial){

    taskBlocSubscription = taskBloc.stream.listen((taskState){
      if(taskState.syncStatus == SyncStatus.pending){
        if(taskState.isLoading) {
          add(HighPrioritySyncRequested());
        } else {
          add(SyncRequested());
        }
      }
    });

    categoryBlocSubscription = categoryBloc.stream.listen((categoryState){
      if(categoryState.syncStatus == SyncStatus.pending){
        if(categoryState.isLoading) {
          add(HighPrioritySyncRequested());
        } else {
          add(SyncRequested());
        }
      }
    });

    foregroundMessagesSubscription = FirebaseMessaging.onMessage.listen((message) {
      final type = message.dataNotificationType;
      if(type == DataNotificationType.newData) add(HighPrioritySyncRequested());
    });

    on<SyncLoaded>((event, emit) {
      final currentUserId = authBloc.state.user?.id;
      if(state.userId != currentUserId){
        emit(SyncState.initial.copyWith(
          userId: currentUserId
        ));
      }
    });
    add(SyncLoaded());

    on<BackgroundSyncRequested>((event, emit) => sync(event, emit));

    on<HighPrioritySyncRequested>((event, emit) => sync(event, emit),
    transformer: debounceTransformer(const Duration(milliseconds: 1500)));

    on<SyncRequested>((event, emit) => sync(event, emit),
    transformer: debounceTransformer(const Duration(seconds: 5)));
  }

  Future<void> sync(SyncEvent event, Emitter<SyncState> emit) async{
    debugPrint("Sync requested");

    final taskState = taskBloc.state;
    final categoryState = categoryBloc.state;

    final tempDate = DateTime.now();

    final updatedTasks = itemsUpdatedAfterDate<Task>(
      date: state.lastSync,
      items: taskState.tasks + taskState.deletedTasks,
      failedItems: taskState.failedTasks
    );

    final updatedCategories = itemsUpdatedAfterDate<Category>(
      date: state.lastSync,
      items: categoryState.categories + categoryState.deletedCategories,
      failedItems: categoryState.failedCategories
    );

    debugPrint("Sync | Enviando peticion a la API...");
    
    await Future.delayed(const Duration(seconds: 2));
    final responseItems = await syncRepository.sync(
      lastSync: state.lastSync,
      tasks: updatedTasks,
      categories: updatedCategories
    );
    debugPrint("Sync | Respuesta de la API recibida...");
    debugPrint("Sync | Response: $responseItems");

    if(responseItems != null){

      final newTaskState = taskBloc.state;
      final newCategoryState = categoryBloc.state;

      responseItems.when(
        left: (duplicated){

          final duplicatedId = duplicated.item1;
          final objectType = duplicated.item2;

          if(objectType is Task){
            final mergedDuplicatedId = mergeDuplicatedId<Task>(
              items: newTaskState.tasks,
              failedItems: newTaskState.failedTasks,
              duplicatedId: duplicatedId
            );
            if(mergedDuplicatedId == null) return;

            taskBloc.add(TaskStateUpdated(newTaskState.copyWith(
              syncStatus: SyncStatus.pending,
              tasks: mergedDuplicatedId.item1,
              failedTasks: mergedDuplicatedId.item2
            )));
          }
          else if(objectType is Category){
            final mergedDuplicatedId = mergeDuplicatedId<Category>(
              items: newCategoryState.categories,
              failedItems: newCategoryState.failedCategories,
              duplicatedId: duplicatedId
            );
            if(mergedDuplicatedId == null) return;

            categoryBloc.add(CategoryStateUpdated(newCategoryState.copyWith(
              syncStatus: SyncStatus.pending,
              categories: mergedDuplicatedId.item1,
              failedCategories: mergedDuplicatedId.item2
            )));
          }
        },

        right: (replaceItems){

          final replaceTasks = replaceItems.item1;
          final replaceCategories = replaceItems.item2;

          if(replaceTasks.isNotEmpty){
            final mergedTasks = mergeItems<Task>(
              currentItems: newTaskState.tasks,
              currentDeletedItems: newTaskState.deletedTasks,
              currentFailedItems: newTaskState.failedTasks,
              replaceItems: replaceItems.item1
            );

            if(mergedTasks != null) {
              taskBloc.add(TaskStateUpdated(newTaskState.copyWith(
                syncStatus: SyncStatus.idle,
                tasks: mergedTasks.item1,
                deletedTasks: mergedTasks.item2,
                failedTasks: mergedTasks.item3
              )));
            }
          }
          else{
            taskBloc.add(TaskStateUpdated(newTaskState.copyWith(
              syncStatus: SyncStatus.idle
            )));
          }

          if(replaceCategories.isNotEmpty){
            final mergedCategories = mergeItems<Category>(
              currentItems: newCategoryState.categories,
              currentDeletedItems: newCategoryState.deletedCategories,
              currentFailedItems: newCategoryState.failedCategories,
              replaceItems: replaceItems.item2
            );

            if(mergedCategories != null) {
              categoryBloc.add(CategoryStateUpdated(newCategoryState.copyWith(
                syncStatus: SyncStatus.idle,
                categories: mergedCategories.item1,
                deletedCategories: mergedCategories.item2,
                failedCategories: mergedCategories.item3
              )));
            }
          }
          else{
            categoryBloc.add(CategoryStateUpdated(newCategoryState.copyWith(
              syncStatus: SyncStatus.idle
            )));
          }

          emit(state.copyWith(lastSync: tempDate));
        }
      );
    }
    else{
      taskBloc.add(TaskStateUpdated(taskBloc.state.copyWith(
        syncStatus: SyncStatus.idle
      )));
      categoryBloc.add(CategoryStateUpdated(categoryBloc.state.copyWith(
        syncStatus: SyncStatus.idle
      )));
    }
  }

  @override
  Future<void> close() async {
    await taskBlocSubscription.cancel();
    await categoryBlocSubscription.cancel();
    await foregroundMessagesSubscription.cancel();
    return super.close();
  }

  @override
  SyncState? fromJson(Map<String, dynamic> json) {
    try{
      debugPrint("SyncBloc fromJson");
      return SyncState.fromJson(json);
    }
    catch(error) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(SyncState state) {
    try{
      debugPrint("SyncBloc toJson");
      return state.toJson();
    }
    catch(error) {
      return null;
    }
  }
}