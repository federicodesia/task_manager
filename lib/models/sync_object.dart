import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/sync_item_error.dart';
import 'package:task_manager/models/task.dart';

part 'sync_object.freezed.dart';

@freezed
class SyncObject with _$SyncObject {
  const SyncObject._();

  const factory SyncObject.task({
    required List<Task> items,
    required List<SyncItemError> failedItems
  }) = SyncObjectTask;

  const factory SyncObject.category({
    required List<Category> items,
    required List<SyncItemError> failedItems
  }) = SyncObjectCategory;

  static List<T>? listFromJson<T>(dynamic json){
    try{
      if(T == Task) return List<T>.from(json.map((t) => Task.fromJson(t)));
    }
    catch(_){}
  }
}