import 'package:task_manager/blocs/sync_bloc/dynamic_functions.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/sync_item_error.dart';
import 'package:task_manager/models/sync_status.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/sync_repository.dart';
import 'package:tuple/tuple.dart';

class SyncService{

  Future<DateTime?> sync({
    required DateTime? lastSync,
    required SyncRepository syncRepository,

    required Tuple3<List<Task>, List<Task>, Map<String, SyncErrorType>>? Function() onGetTasks,
    required Tuple3<List<Category>, List<Category>, Map<String, SyncErrorType>>? Function() onGetCategories,

    required Function(SyncStatus, Tuple3<List<Task>, List<Task>, Map<String, SyncErrorType>>) onMergeTasks,
    required Function(SyncStatus, Tuple3<List<Category>, List<Category>, Map<String, SyncErrorType>>) onMergeCategories,
  }) async{

    print("Sync requested");
    final tempDate = DateTime.now();

    final tasks = onGetTasks();
    final categories = onGetCategories();
    if(tasks == null || categories == null) return null;

    final updatedTasks = itemsUpdatedAfterDate<Task>(
      date: lastSync,
      items: tasks.item1 + tasks.item2,
      failedItems: tasks.item3
    );

    final updatedCategories = itemsUpdatedAfterDate<Category>(
      date: lastSync,
      items: categories.item1 + categories.item2,
      failedItems: categories.item3
    );

    print("Sync | Enviando peticion a la API...");
    final response = await syncRepository.sync(
      lastSync: lastSync,
      tasks: updatedTasks,
      categories: updatedCategories
    );
    print("Sync | Respuesta de la API recibida...");

    if(response != null){

      final newTasks = onGetTasks();
      final newCategories = onGetCategories();
      if(newTasks == null || newCategories == null) return null;

      response.when(
        left: (duplicated){

          final duplicatedId = duplicated.item1;
          final objectType = duplicated.item2;

          if(objectType is Task){
            final mergedDuplicatedId = mergeDuplicatedId<Task>(
              items: newTasks.item1,
              deletedItems: newTasks.item2,
              failedItems: newTasks.item3,
              duplicatedId: duplicatedId
            );
            if(mergedDuplicatedId == null) return;
            onMergeTasks(SyncStatus.pending, mergedDuplicatedId);
          }

          else if(objectType is Category){
            final mergedDuplicatedId = mergeDuplicatedId<Category>(
              items: newCategories.item1,
              deletedItems: newCategories.item2,
              failedItems: newCategories.item3,
              duplicatedId: duplicatedId
            );
            if(mergedDuplicatedId == null) return;
            onMergeCategories(SyncStatus.pending, mergedDuplicatedId);
          }
        },

        right: (replaceItems){

          final replaceTasks = replaceItems.item1;
          final replaceCategories = replaceItems.item2;

          if(replaceTasks.isNotEmpty){
            final mergedTasks = mergeItems<Task>(
              currentItems: newTasks.item1,
              currentDeletedItems: newTasks.item2,
              currentFailedItems: newTasks.item3,
              replaceItems: replaceTasks
            );
            if(mergedTasks != null) onMergeTasks(SyncStatus.idle, mergedTasks);
          }

          if(replaceCategories.isNotEmpty){
            final mergedCategories = mergeItems<Category>(
              currentItems: newCategories.item1,
              currentDeletedItems: newCategories.item2,
              currentFailedItems: newCategories.item3,
              replaceItems: replaceCategories
            );
            if(mergedCategories != null) onMergeCategories(SyncStatus.idle, mergedCategories);
          }

          return tempDate;
        }
      );
    }
  }
}