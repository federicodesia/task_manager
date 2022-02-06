import 'package:task_manager/models/sync_item_error.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

Tuple2<List<T>, Map<String, SyncErrorType>>? mergeDuplicatedId<T>({
  required List<dynamic> items,
  required Map<String, SyncErrorType> failedItems,
  required String duplicatedId
}){
  try{

    final failedItem = failedItems[duplicatedId];
    if(failedItem != null){
      if(failedItem == SyncErrorType.duplicatedId)
        failedItems[duplicatedId] = SyncErrorType.blacklist;
    }
    else{
      final index = items.lastIndexWhere((i) => i.id == duplicatedId);
      if(index != -1){
        final newId = Uuid().v4();
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
}

Map<String, SyncErrorType>? removeDuplicatedId({
  required Map<String, SyncErrorType> failedItems,
  required List<dynamic> replaceItems,
}){
  try{
    replaceItems.forEach((item) => failedItems.remove(item.key));
    return failedItems;
  }
  catch(_){}
}

List<T>? itemsUpdatedAfterDate<T>({
  required DateTime? date,
  required List<dynamic> items,
  required Map<String, SyncErrorType> failedItems
}){
  try{
    if(date != null) items = items..removeWhere((i) => 
      i.id == null
      || failedItems[i.id] == SyncErrorType.blacklist
      || !i.updatedAt.isAfter(date)
    );
    else items = items..removeWhere((i) => 
      i.id == null
      || failedItems[i.id] == SyncErrorType.blacklist
    );
    return items.isNotEmpty ? List<T>.from(items) : null;
  }
  catch(_){}
}

Tuple2<List<T>, List<T>>? mergeItems<T>({
  required DateTime date,
  required List<dynamic> currentItems,
  required List<dynamic> currentDeletedItems,
  required List<dynamic> replaceItems
}){
  try{
    final updatedItems = [];
    final deletedItems = [];
    replaceItems.forEach((r) => r.deletedAt != null ? deletedItems.add(r) : updatedItems.add(r));

    currentDeletedItems.removeWhere((c) => !c.deletedAt.isAfter(date) && deletedItems.any((d) => c.id == d.id));
    
    currentItems = currentItems.map((c){
      if(c.updatedAt.isAfter(date)) return c;
      return updatedItems.firstWhereOrNull((u) => u.id == c.id) ?? c;
    }).toList();
    
    return Tuple2(
      List<T>.from(currentItems),
      List<T>.from(currentDeletedItems)
    );
  }
  catch(_){}
}