part of 'sync_bloc.dart';

abstract class SyncEvent {}

class SyncRequested extends SyncEvent {}
class HighPrioritySyncRequested extends SyncEvent {}