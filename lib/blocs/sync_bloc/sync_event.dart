part of 'sync_bloc.dart';

abstract class SyncEvent {}

class SyncLoaded extends SyncEvent {}

class SyncRequested extends SyncEvent {}
class BackgroundSyncRequested extends SyncEvent {}
class HighPrioritySyncRequested extends SyncEvent {}