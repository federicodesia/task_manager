import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/repositories/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {

  final CategoryRepository categoryRepository;
  final TaskBloc taskBloc;
  late StreamSubscription tasksSubscription;

  CategoryBloc({
    required this.categoryRepository,
    required this.taskBloc
  }) : super(CategoryLoadInProgress()){

    on<CategoryLoaded>((event, emit) async{
      try{
        final categories = await categoryRepository.fetchCategories();
        emit(CategoryLoadSuccess(categories));
      }
      catch(_){
        emit(CategoryLoadFailure());
      }
    });

    on<CategoryAdded>((event, emit){
      if(state is CategoryLoadSuccess){
        emit(CategoryLoadSuccess((state as CategoryLoadSuccess).categories..add(event.category)));
      }
    });

    on<CategoryUpdated>((event, emit){
      if(state is CategoryLoadSuccess){
        emit(CategoryLoadSuccess((state as CategoryLoadSuccess).categories.map((category){
          return category.uuid == event.category.uuid ? event.category : category;
        }).toList()));
      }
    });

    on<CategoryDeleted>((event, emit){
      if(state is CategoryLoadSuccess){
        emit(CategoryLoadSuccess((state as CategoryLoadSuccess).categories
          .where((category) => category.uuid != event.category.uuid).toList()));
        
        TaskState taskBlocState = taskBloc.state;
        if(taskBlocState is TaskLoadSuccess){
          taskBloc.add(TasksUpdated(
            taskBlocState.tasks.map((task){
              return task.categoryUuid == event.category.uuid ? task.copyWith(categoryUuid: null) : task;
            }).toList())
          );
        }
      }
    });
  }

  @override
  Future<void> close() {
    tasksSubscription.cancel();
    return super.close();
  }
}