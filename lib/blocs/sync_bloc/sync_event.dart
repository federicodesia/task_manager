part of 'sync_bloc.dart';

@immutable
abstract class SyncEvent {}

class SyncPullRequested extends SyncEvent {}

class SyncPushRequested extends SyncEvent {
  final SyncObject syncObject;
  SyncPushRequested({required this.syncObject});
}