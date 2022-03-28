import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'drifted_storage.dart';

const _asyncRunZoned = runZoned;

class DriftedBlocOverrides extends BlocOverrides {
  static final _token = Object();

  static DriftedBlocOverrides? get current {
    return Zone.current[_token] as DriftedBlocOverrides?;
  }
  
  static R runZoned<R>(
    R Function() body, {
    BlocObserver? blocObserver,
    EventTransformer? eventTransformer,
    DriftedStorage? storage,
  }) {
    final overrides = _DriftedBlocOverridesScope(storage);
    return BlocOverrides.runZoned(
      () => _asyncRunZoned(body, zoneValues: {_token: overrides}),
      blocObserver: blocObserver,
      eventTransformer: eventTransformer,
    );
  }

  @override
  BlocObserver get blocObserver {
    return BlocOverrides.current?.blocObserver ?? super.blocObserver;
  }

  @override
  EventTransformer get eventTransformer {
    return BlocOverrides.current?.eventTransformer ?? super.eventTransformer;
  }

  DriftedStorage get storage => _defaultDriftedStorage;
}

class _DriftedBlocOverridesScope extends DriftedBlocOverrides {
  _DriftedBlocOverridesScope(this._storage);

  final DriftedBlocOverrides? _previous = DriftedBlocOverrides.current;
  final DriftedStorage? _storage;

  @override
  DriftedStorage get storage {
    final storage = _storage;
    if (storage != null) return storage;

    final previous = _previous;
    if (previous != null) return previous.storage;

    return super.storage;
  }
}

abstract class DriftedBloc<Event, State> extends Bloc<Event, State> with DriftedMixin {
  DriftedBloc(State state) : super(state) {
    _init();
  }
}

abstract class DriftedCubit<State> extends Cubit<State> with DriftedMixin<State> {
  DriftedCubit(State state) : super(state) {
    _init();
  }
}

mixin DriftedMixin<State> on BlocBase<State> {
  
  late final _overrides = DriftedBlocOverrides.current;
  late final StreamSubscription<dynamic>? _storageSubscription;

  DriftedStorage get _storage {
    final storage = _overrides?.storage;
    if (storage == null) throw const DriftedStorageNotFound();
    if (storage is _DefaultDriftedStorage) throw const DriftedStorageNotFound();
    return storage;
  }

  void _init() {
    _storageSubscription = _storage.watch(storageToken)?.listen((driftedState) {
      if(driftedState != null){
        if(_updatedAt != null && driftedState.updatedAt.isAfter(_updatedAt!)){
         
          final newState = _fromJson(driftedState.state);
          if(newState != null){

            final a = jsonEncode(_toJson(state));
            final b = jsonEncode(driftedState.state);
            
            if(a != b) emit(newState);
          }
        }
      }
    });
  }

  State? driftedRead() {
    try {
      final drifedState = _storage.read(storageToken);
      if(drifedState != null){
        final stateJson = drifedState.state;
        if (stateJson != null){
          final cachedState = _fromJson(stateJson);
          if(cachedState != null){
            _updatedAt = drifedState.updatedAt;
            return cachedState;
          }
        }
      }
    } catch (error, stackTrace) {
      onError(error, stackTrace);
      if (error is DriftedStorageNotFound) rethrow;
    }
    return null;
  }

  Future<void> driftedWrite({State? newState}) async {
    try {
      final stateJson = _toJson(newState ?? state);
      if (stateJson != null) {
        final updatedAt = DateTime.now().toUtc();
        await _storage.write(storageToken, stateJson, updatedAt);
        _updatedAt = updatedAt;
      }
    } catch (error, stackTrace) {
      onError(error, stackTrace);
      if (error is DriftedStorageNotFound) rethrow;
    }
  }

  DateTime? _updatedAt;
  State? _state;

  @override
  State get state {
    if (_state != null) return _state!;
    final cachedState = driftedRead();
    if(cachedState != null){
      _state = cachedState;
      return cachedState;
    }
    _state = super.state;
    return super.state;
  }

  @override
  void onChange(Change<State> change) async {
    super.onChange(change);

    final nextState = change.nextState;
    _state = nextState;

    await driftedWrite(newState: nextState);
  }

  @override
  Future<void> close() async {
    await _storageSubscription?.cancel();
    super.close();
  }

  State? _fromJson(dynamic json) {
    final dynamic traversedJson = _traverseRead(json);
    final castJson = _cast<Map<String, dynamic>>(traversedJson);
    return fromJson(castJson ?? <String, dynamic>{});
  }

  Map<String, dynamic>? _toJson(State state) {
    return _cast<Map<String, dynamic>>(_traverseWrite(toJson(state)).value);
  }

  dynamic _traverseRead(dynamic value) {
    if (value is Map) {
      return value.map<String, dynamic>((dynamic key, dynamic value) {
        return MapEntry<String, dynamic>(
          _cast<String>(key) ?? '',
          _traverseRead(value),
        );
      });
    }
    if (value is List) {
      for (var i = 0; i < value.length; i++) {
        value[i] = _traverseRead(value[i]);
      }
    }
    return value;
  }

  T? _cast<T>(dynamic x) => x is T ? x : null;

  _Traversed _traverseWrite(Object? value) {
    final dynamic traversedAtomicJson = _traverseAtomicJson(value);
    if (traversedAtomicJson is! NIL) {
      return _Traversed.atomic(traversedAtomicJson);
    }
    final dynamic traversedComplexJson = _traverseComplexJson(value);
    if (traversedComplexJson is! NIL) {
      return _Traversed.complex(traversedComplexJson);
    }
    try {
      _checkCycle(value);
      final dynamic customJson = _toEncodable(value);
      final dynamic traversedCustomJson = _traverseJson(customJson);
      if (traversedCustomJson is NIL) {
        throw DriftedUnsupportedError(value);
      }
      _removeSeen(value);
      return _Traversed.complex(traversedCustomJson);
    } on DriftedCyclicError catch (e) {
      throw DriftedUnsupportedError(value, cause: e);
    } on DriftedUnsupportedError {
      rethrow; // do not stack `DriftedUnsupportedError`
    } catch (e) {
      throw DriftedUnsupportedError(value, cause: e);
    }
  }

  dynamic _traverseAtomicJson(dynamic object) {
    if (object is num) {
      if (!object.isFinite) return const NIL();
      return object;
    } else if (identical(object, true)) {
      return true;
    } else if (identical(object, false)) {
      return false;
    } else if (object == null) {
      return null;
    } else if (object is String) {
      return object;
    }
    return const NIL();
  }

  dynamic _traverseComplexJson(dynamic object) {
    if (object is List) {
      if (object.isEmpty) return object;
      _checkCycle(object);
      List<dynamic>? list;
      for (var i = 0; i < object.length; i++) {
        final traversed = _traverseWrite(object[i]);
        list ??= traversed.outcome == _Outcome.atomic
            ? object.sublist(0)
            : (<dynamic>[]..length = object.length);
        list[i] = traversed.value;
      }
      _removeSeen(object);
      return list;
    } else if (object is Map) {
      _checkCycle(object);
      final map = <String, dynamic>{};
      object.forEach((dynamic key, dynamic value) {
        final castKey = _cast<String>(key);
        if (castKey != null) {
          map[castKey] = _traverseWrite(value).value;
        }
      });
      _removeSeen(object);
      return map;
    }
    return const NIL();
  }

  dynamic _traverseJson(dynamic object) {
    final dynamic traversedAtomicJson = _traverseAtomicJson(object);
    return traversedAtomicJson is! NIL
        ? traversedAtomicJson
        : _traverseComplexJson(object);
  }

  dynamic _toEncodable(dynamic object) => object.toJson();

  final List _seen = <dynamic>[];

  void _checkCycle(Object? object) {
    for (var i = 0; i < _seen.length; i++) {
      if (identical(object, _seen[i])) {
        throw DriftedCyclicError(object);
      }
    }
    _seen.add(object);
  }

  void _removeSeen(dynamic object) {
    assert(_seen.isNotEmpty);
    assert(identical(_seen.last, object));
    _seen.removeLast();
  }

  String get id => '';
  
  @nonVirtual
  String get storageToken => '${runtimeType.toString()}$id';

  Future<void> clear() => _storage.delete(storageToken);

  State? fromJson(Map<String, dynamic> json);
  Map<String, dynamic>? toJson(State state);
}

class DriftedCyclicError extends DriftedUnsupportedError {
  DriftedCyclicError(Object? object) : super(object);

  @override
  String toString() => 'Cyclic error while state traversing';
}

class DriftedStorageNotFound implements Exception {
  const DriftedStorageNotFound();

  @override
  String toString() => "DriftedStorageNotFound";
}

class DriftedUnsupportedError extends Error {
  DriftedUnsupportedError(
    this.unsupportedObject, {
    this.cause,
  });

  final Object? unsupportedObject;
  final Object? cause;

  @override
  String toString() {
    final safeString = Error.safeToString(unsupportedObject);
    final prefix = cause != null
        ? 'Converting object to an encodable object failed:'
        : 'Converting object did not return an encodable object:';
    return '$prefix $safeString';
  }
}

@visibleForTesting
class NIL {
  const NIL();
}

enum _Outcome { atomic, complex }

class _Traversed {
  _Traversed._({required this.outcome, required this.value});
  _Traversed.atomic(dynamic value)
      : this._(outcome: _Outcome.atomic, value: value);
  _Traversed.complex(dynamic value)
      : this._(outcome: _Outcome.complex, value: value);
  final _Outcome outcome;
  final dynamic value;
}

late final _defaultDriftedStorage = _DefaultDriftedStorage();

class _DefaultDriftedStorage implements DriftedStorage {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}