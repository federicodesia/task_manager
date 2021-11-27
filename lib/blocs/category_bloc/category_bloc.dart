import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/repositories/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {

  final CategoryRepository categoryRepository;
  CategoryBloc({required this.categoryRepository}) : super(CategoryLoadInProgress()){

    on<CategoryLoaded>((event, emit) async{
      try{
        final categories = await categoryRepository.fetchCategories();
        emit(CategoryLoadSuccess(categories));
      }
      catch(_){
        emit(CategoryLoadFailure());
      }
    });

    on<CategoryAdded>((event, emit) => emit(CategoryLoadSuccess((state as CategoryLoadSuccess).categories..add(event.category))));

    on<CategoryUpdated>((event, emit) => emit(CategoryLoadSuccess((state as CategoryLoadSuccess).categories.map((category){
      return category.uuid == event.category.uuid ? event.category : category;
    }).toList())));

    on<CategoryDeleted>((event, emit) => emit(CategoryLoadSuccess((state as CategoryLoadSuccess).categories
      .where((category) => category.uuid != event.category.uuid).toList())));
  }
}