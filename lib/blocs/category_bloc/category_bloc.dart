import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/sync_item_error.dart';
import 'package:task_manager/models/sync_status.dart';
import 'package:task_manager/repositories/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

part 'category_bloc.g.dart';

class CategoryBloc extends HydratedBloc<CategoryEvent, CategoryState> {

  final CategoryRepository categoryRepository;
  final TaskBloc taskBloc;

  CategoryBloc({
    required this.categoryRepository,
    required this.taskBloc
  }) : super(CategoryLoadSuccess.initial()){

    // TODO: Remove event
    on<CategoryLoaded>((event, emit) async{});

    on<CategoryAdded>((event, emit){
      final categoryState = state;
      if(categoryState is CategoryLoadSuccess){
        emit(categoryState.copyWith(categories: categoryState.categories..add(event.category)));
      }
    });

    on<CategoryUpdated>((event, emit){
      final categoryState = state;
      if(categoryState is CategoryLoadSuccess){
        emit(categoryState.copyWith(categories: categoryState.categories.map((category){
          return category.id == event.category.id ? event.category : category;
        }).toList()));
      }
    });

    on<CategoryDeleted>((event, emit){
      final categoryState = state;
      if(categoryState is CategoryLoadSuccess){
        emit(categoryState.copyWith(
          categories: categoryState.categories..removeWhere((c) => c.id == event.category.id),
          deletedCategories: categoryState.deletedCategories..add(event.category.copyWith(deletedAt: DateTime.now()))
        ));
        
        final taskBlocState = taskBloc.state;
        if(taskBlocState is TaskLoadSuccess){
          taskBloc.add(TaskStateUpdated(taskBlocState.copyWith(
            tasks: taskBlocState.tasks.map((task){
              return task.categoryId == event.category.id ? task.copyWith(categoryId: null) : task;
            }).toList()
          )));
        }
      }
    });

    on<CategoryStateUpdated>((event, emit){
      print("Actualizando CategoryState...");
      final categoryState = event.state;
      if(categoryState is CategoryLoadSuccess){
        print("SyncPushStatus: " + categoryState.syncPushStatus.name);
        print("Categories: ${categoryState.categories}");
        print("DeletedCategories: ${categoryState.deletedCategories}");
        print("FailedCategories: ${categoryState.failedCategories}");
      }
      emit(event.state);
    },
    transformer: restartable());
  }

  @override
  CategoryState? fromJson(Map<String, dynamic> json) {
    try{
      print("categoryBloc fromJson");
      return CategoryLoadSuccess.fromJson(json);
    }
    catch(error) {
      print("categoryBloc fromJson error: $error");
    }
  }

  @override
  Map<String, dynamic>? toJson(CategoryState state) {
    try{
      print("categoryBloc toJson");
      final categoryState = state;
      if(categoryState is CategoryLoadSuccess) return categoryState.toJson();
    }
    catch(error) {
      print("categoryBloc toJson error: $error");
    }
  }
}