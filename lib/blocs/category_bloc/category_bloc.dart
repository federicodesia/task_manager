import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/sync_item_error.dart';
import 'package:task_manager/models/sync_status.dart';

part 'category_event.dart';
part 'category_state.dart';

part 'category_bloc.g.dart';

class CategoryBloc extends DriftedBloc<CategoryEvent, CategoryState> {
  
  final bool inBackground;
  final AuthBloc authBloc;
  final TaskBloc taskBloc;

  CategoryBloc({
    required this.inBackground,
    required this.authBloc,
    required this.taskBloc
  }) : super(CategoryState.initial){

    on<CategoryLoaded>((event, emit) {
      final currentUserId = authBloc.state.user?.id;
      if(state.userId != currentUserId){
        emit(CategoryState.initial.copyWith(
          isLoading: false,
          userId: currentUserId,
          syncStatus: SyncStatus.idle
        ));
      }

      if(!inBackground){
        emit(state.copyWith(
          isLoading: true,
          syncStatus: SyncStatus.pending
        ));
      }
    });
    add(CategoryLoaded());

    on<CategoryAdded>((event, emit){
      final categoryState = state;
      emit(categoryState.copyWith(
        categories: categoryState.categories..add(event.category)
      ));
    });

    on<CategoryUpdated>((event, emit){
      final categoryState = state;
      emit(categoryState.copyWith(categories: categoryState.categories.map((category){
        return category.id == event.category.id ? event.category : category;
      }).toList()));
    });

    on<CategoryDeleted>((event, emit){
      final categoryState = state;
      emit(categoryState.copyWith(
        categories: categoryState.categories..removeWhere((c) => c.id == event.category.id),
        deletedCategories: categoryState.deletedCategories..add(event.category.copyWith(deletedAt: DateTime.now()))
      ));
      
      final taskBlocState = taskBloc.state;
      taskBloc.add(TaskStateUpdated(taskBlocState.copyWith(
        tasks: taskBlocState.tasks.map((task){
          return task.categoryId == event.category.id ? task.copyWith(categoryId: null) : task;
        }).toList()
      )));
    });

    on<CategoryStateUpdated>((event, emit){
      debugPrint("Actualizando CategoryState...");
      emit(event.state.copyWith(
        isLoading: false,
        syncStatus: event.state.syncStatus
      ));
    },
    transformer: restartable());
  }

  @override
  CategoryState? fromJson(Map<String, dynamic> json) {
    try{
      debugPrint("CategoryBloc fromJson");
      return CategoryState.fromJson(json);
    }
    catch(error) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CategoryState state) {
    try{
      debugPrint("CategoryBloc toJson");
      return state.toJson();
    }
    catch(error) {
      return null;
    }
  }
}