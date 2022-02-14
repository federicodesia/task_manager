part of 'sync_bloc.dart';

@immutable
abstract class SyncEvent {}

class SyncRequested extends SyncEvent {}

class BackgroundSyncRequested extends SyncEvent {}

class SyncReloadStateRequested extends SyncEvent {
  final Map<String, dynamic>? json;
  SyncReloadStateRequested({required this.json});
}