part of 'sync_bloc.dart';

@immutable
abstract class SyncEvent {}

class SyncRequested extends SyncEvent {}