import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/sync_bloc/events/dynamic_functions.dart';
import 'package:task_manager/blocs/sync_bloc/sync_bloc.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/sync_status.dart';

void onPushCategoryRequested(
  SyncBloc bloc,
  SyncPushCategoryRequested event,
  Emitter<SyncState> emit
) async{

  print("PushCategory requested");
  final tempDate = DateTime.now();

  final updatedCategories = itemsUpdatedAfterDate<Category>(
    date: bloc.state.lastCategoryPush,
    items: event.categories,
    failedItems: event.failedCategories
  );
  if(updatedCategories == null) return;

  print("PushCategory | Enviando peticion a la API...");
  await Future.delayed(Duration(seconds: 2));
  final responseItems = await bloc.syncRepository.push<Category>(
    queryPath: "categories",
    items: updatedCategories
  );
  print("PushCategory | Respuesta de la API recibida...");

  final categoryBloc = bloc.categoryBloc;
  final categoryState = categoryBloc.state;
  if(categoryState is! CategoryLoadSuccess) return;

  if(responseItems != null) responseItems.when(
    left: (duplicatedId) {
      final mergedDuplicatedId = mergeDuplicatedId<Category>(
        items: categoryState.categories,
        failedItems: categoryState.failedCategories,
        duplicatedId: duplicatedId
      );
      if(mergedDuplicatedId == null) return;

      categoryBloc.add(CategoryStateUpdated(categoryState.copyWith(
        syncPushStatus: SyncStatus.pending,
        categories: mergedDuplicatedId.item1,
        failedCategories: mergedDuplicatedId.item2
      )));
    },
    right: (items){
      final mergedCategories = mergeItems<Category>(
        date: tempDate,
        currentItems: categoryState.categories,
        currentDeletedItems: categoryState.deletedCategories,
        replaceItems: items
      );
      if(mergedCategories == null) return;

      categoryBloc.add(CategoryStateUpdated(categoryState.copyWith(
        syncPushStatus: SyncStatus.idle,
        categories: mergedCategories.item1,
        deletedCategories: mergedCategories.item2,
        failedCategories: removeDuplicatedId(
          failedItems: categoryState.failedCategories,
          replaceItems: items
        )
      )));

      emit(bloc.state.copyWith(lastCategoryPush: tempDate));
    }
  );
}