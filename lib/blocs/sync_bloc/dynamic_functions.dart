import 'package:task_manager/models/sync_item_error.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

List<T> itemsUpdatedAfterDate<T>({
  required DateTime? date,
  required List<dynamic> items,
  required Map<String, SyncErrorType> failedItems
}){
  try{
    if(date != null) {
      items = items..removeWhere((i) => 
        i.id == null
        || failedItems[i.id] == SyncErrorType.blacklist
        || !i.updatedAt.isAfter(date)
    );
    } else {
      items = items..removeWhere((i) => 
        i.id == null
        || failedItems[i.id] == SyncErrorType.blacklist
      );
    }
    return List<T>.from(items);
  }
  catch(_){
    return List<T>.empty();
  }
}

Tuple2<List<T>, Map<String, SyncErrorType>>? mergeDuplicatedId<T>({
  required List<dynamic> items,
  required Map<String, SyncErrorType> failedItems,
  required String duplicatedId
}){
  try{

    final failedItem = failedItems[duplicatedId];
    if(failedItem != null){
      if(failedItem == SyncErrorType.duplicatedId) {
        failedItems[duplicatedId] = SyncErrorType.blacklist;
      }
    }
    else{
      final index = items.lastIndexWhere((i) => i.id == duplicatedId);
      if(index != -1){
        final newId = const Uuid().v4();
        failedItems[newId] = SyncErrorType.duplicatedId;
        items[index] = items.elementAt(index).copyWith(id: newId);
      }
    }

    return Tuple2(
      List<T>.from(items),
      failedItems
    );
  }
  catch(_){}
  return null;
}

Tuple3<
  List<T>,
  List<T>,
  Map<String, SyncErrorType>
>? mergeItems<T>({
  required List<dynamic> currentItems,
  required List<dynamic> currentDeletedItems,
  required Map<String, SyncErrorType> currentFailedItems,
  required List<dynamic> replaceItems
}){
  try{
    final updatedItems = [];
    final deletedItems = [];

    for(dynamic r in replaceItems) {
      r.deletedAt != null ? deletedItems.add(r) : updatedItems.add(r);
      currentFailedItems.remove(r.id);
    }

    currentDeletedItems.removeWhere((c){
      final deleted = deletedItems.firstWhereOrNull((d) => d.id == c.id);
      if(deleted != null && deleted.deletedAt.isAfter(c.deletedAt)) return true;
      return false;
    });

    currentItems.removeWhere((c){
      final deleted = deletedItems.firstWhereOrNull((d) => d.id == c.id);
      if(deleted != null && deleted.updatedAt.isAfter(c.updatedAt)) return true;
      return false;
    });
    
    currentItems = currentItems.map((c){
      final updated = updatedItems.firstWhereOrNull((u) => u.id == c.id);
      updatedItems.remove(updated);

      if(updated != null && updated.updatedAt.isAfter(c.updatedAt)) return updated;
      return c;
    }).toList()..addAll(updatedItems);
    
    return Tuple3(
      List<T>.from(currentItems),
      List<T>.from(currentDeletedItems),
      currentFailedItems
    );
  }
  catch(_){}
  return null;
}