// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'sync_object.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SyncObjectTearOff {
  const _$SyncObjectTearOff();

  SyncObjectTask task(
      {required List<Task> items, required List<SyncItemError> failedItems}) {
    return SyncObjectTask(
      items: items,
      failedItems: failedItems,
    );
  }

  SyncObjectCategory category(
      {required List<Category> items,
      required List<SyncItemError> failedItems}) {
    return SyncObjectCategory(
      items: items,
      failedItems: failedItems,
    );
  }
}

/// @nodoc
const $SyncObject = _$SyncObjectTearOff();

/// @nodoc
mixin _$SyncObject {
  List<SyncItemError> get failedItems => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Task> items, List<SyncItemError> failedItems)
        task,
    required TResult Function(
            List<Category> items, List<SyncItemError> failedItems)
        category,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<Task> items, List<SyncItemError> failedItems)? task,
    TResult Function(List<Category> items, List<SyncItemError> failedItems)?
        category,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Task> items, List<SyncItemError> failedItems)? task,
    TResult Function(List<Category> items, List<SyncItemError> failedItems)?
        category,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncObjectTask value) task,
    required TResult Function(SyncObjectCategory value) category,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SyncObjectTask value)? task,
    TResult Function(SyncObjectCategory value)? category,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncObjectTask value)? task,
    TResult Function(SyncObjectCategory value)? category,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SyncObjectCopyWith<SyncObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncObjectCopyWith<$Res> {
  factory $SyncObjectCopyWith(
          SyncObject value, $Res Function(SyncObject) then) =
      _$SyncObjectCopyWithImpl<$Res>;
  $Res call({List<SyncItemError> failedItems});
}

/// @nodoc
class _$SyncObjectCopyWithImpl<$Res> implements $SyncObjectCopyWith<$Res> {
  _$SyncObjectCopyWithImpl(this._value, this._then);

  final SyncObject _value;
  // ignore: unused_field
  final $Res Function(SyncObject) _then;

  @override
  $Res call({
    Object? failedItems = freezed,
  }) {
    return _then(_value.copyWith(
      failedItems: failedItems == freezed
          ? _value.failedItems
          : failedItems // ignore: cast_nullable_to_non_nullable
              as List<SyncItemError>,
    ));
  }
}

/// @nodoc
abstract class $SyncObjectTaskCopyWith<$Res>
    implements $SyncObjectCopyWith<$Res> {
  factory $SyncObjectTaskCopyWith(
          SyncObjectTask value, $Res Function(SyncObjectTask) then) =
      _$SyncObjectTaskCopyWithImpl<$Res>;
  @override
  $Res call({List<Task> items, List<SyncItemError> failedItems});
}

/// @nodoc
class _$SyncObjectTaskCopyWithImpl<$Res> extends _$SyncObjectCopyWithImpl<$Res>
    implements $SyncObjectTaskCopyWith<$Res> {
  _$SyncObjectTaskCopyWithImpl(
      SyncObjectTask _value, $Res Function(SyncObjectTask) _then)
      : super(_value, (v) => _then(v as SyncObjectTask));

  @override
  SyncObjectTask get _value => super._value as SyncObjectTask;

  @override
  $Res call({
    Object? items = freezed,
    Object? failedItems = freezed,
  }) {
    return _then(SyncObjectTask(
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Task>,
      failedItems: failedItems == freezed
          ? _value.failedItems
          : failedItems // ignore: cast_nullable_to_non_nullable
              as List<SyncItemError>,
    ));
  }
}

/// @nodoc

class _$SyncObjectTask extends SyncObjectTask {
  const _$SyncObjectTask({required this.items, required this.failedItems})
      : super._();

  @override
  final List<Task> items;
  @override
  final List<SyncItemError> failedItems;

  @override
  String toString() {
    return 'SyncObject.task(items: $items, failedItems: $failedItems)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SyncObjectTask &&
            const DeepCollectionEquality().equals(other.items, items) &&
            const DeepCollectionEquality()
                .equals(other.failedItems, failedItems));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(items),
      const DeepCollectionEquality().hash(failedItems));

  @JsonKey(ignore: true)
  @override
  $SyncObjectTaskCopyWith<SyncObjectTask> get copyWith =>
      _$SyncObjectTaskCopyWithImpl<SyncObjectTask>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Task> items, List<SyncItemError> failedItems)
        task,
    required TResult Function(
            List<Category> items, List<SyncItemError> failedItems)
        category,
  }) {
    return task(items, failedItems);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<Task> items, List<SyncItemError> failedItems)? task,
    TResult Function(List<Category> items, List<SyncItemError> failedItems)?
        category,
  }) {
    return task?.call(items, failedItems);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Task> items, List<SyncItemError> failedItems)? task,
    TResult Function(List<Category> items, List<SyncItemError> failedItems)?
        category,
    required TResult orElse(),
  }) {
    if (task != null) {
      return task(items, failedItems);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncObjectTask value) task,
    required TResult Function(SyncObjectCategory value) category,
  }) {
    return task(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SyncObjectTask value)? task,
    TResult Function(SyncObjectCategory value)? category,
  }) {
    return task?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncObjectTask value)? task,
    TResult Function(SyncObjectCategory value)? category,
    required TResult orElse(),
  }) {
    if (task != null) {
      return task(this);
    }
    return orElse();
  }
}

abstract class SyncObjectTask extends SyncObject {
  const factory SyncObjectTask(
      {required List<Task> items,
      required List<SyncItemError> failedItems}) = _$SyncObjectTask;
  const SyncObjectTask._() : super._();

  List<Task> get items;
  @override
  List<SyncItemError> get failedItems;
  @override
  @JsonKey(ignore: true)
  $SyncObjectTaskCopyWith<SyncObjectTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncObjectCategoryCopyWith<$Res>
    implements $SyncObjectCopyWith<$Res> {
  factory $SyncObjectCategoryCopyWith(
          SyncObjectCategory value, $Res Function(SyncObjectCategory) then) =
      _$SyncObjectCategoryCopyWithImpl<$Res>;
  @override
  $Res call({List<Category> items, List<SyncItemError> failedItems});
}

/// @nodoc
class _$SyncObjectCategoryCopyWithImpl<$Res>
    extends _$SyncObjectCopyWithImpl<$Res>
    implements $SyncObjectCategoryCopyWith<$Res> {
  _$SyncObjectCategoryCopyWithImpl(
      SyncObjectCategory _value, $Res Function(SyncObjectCategory) _then)
      : super(_value, (v) => _then(v as SyncObjectCategory));

  @override
  SyncObjectCategory get _value => super._value as SyncObjectCategory;

  @override
  $Res call({
    Object? items = freezed,
    Object? failedItems = freezed,
  }) {
    return _then(SyncObjectCategory(
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      failedItems: failedItems == freezed
          ? _value.failedItems
          : failedItems // ignore: cast_nullable_to_non_nullable
              as List<SyncItemError>,
    ));
  }
}

/// @nodoc

class _$SyncObjectCategory extends SyncObjectCategory {
  const _$SyncObjectCategory({required this.items, required this.failedItems})
      : super._();

  @override
  final List<Category> items;
  @override
  final List<SyncItemError> failedItems;

  @override
  String toString() {
    return 'SyncObject.category(items: $items, failedItems: $failedItems)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SyncObjectCategory &&
            const DeepCollectionEquality().equals(other.items, items) &&
            const DeepCollectionEquality()
                .equals(other.failedItems, failedItems));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(items),
      const DeepCollectionEquality().hash(failedItems));

  @JsonKey(ignore: true)
  @override
  $SyncObjectCategoryCopyWith<SyncObjectCategory> get copyWith =>
      _$SyncObjectCategoryCopyWithImpl<SyncObjectCategory>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Task> items, List<SyncItemError> failedItems)
        task,
    required TResult Function(
            List<Category> items, List<SyncItemError> failedItems)
        category,
  }) {
    return category(items, failedItems);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<Task> items, List<SyncItemError> failedItems)? task,
    TResult Function(List<Category> items, List<SyncItemError> failedItems)?
        category,
  }) {
    return category?.call(items, failedItems);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Task> items, List<SyncItemError> failedItems)? task,
    TResult Function(List<Category> items, List<SyncItemError> failedItems)?
        category,
    required TResult orElse(),
  }) {
    if (category != null) {
      return category(items, failedItems);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncObjectTask value) task,
    required TResult Function(SyncObjectCategory value) category,
  }) {
    return category(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SyncObjectTask value)? task,
    TResult Function(SyncObjectCategory value)? category,
  }) {
    return category?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncObjectTask value)? task,
    TResult Function(SyncObjectCategory value)? category,
    required TResult orElse(),
  }) {
    if (category != null) {
      return category(this);
    }
    return orElse();
  }
}

abstract class SyncObjectCategory extends SyncObject {
  const factory SyncObjectCategory(
      {required List<Category> items,
      required List<SyncItemError> failedItems}) = _$SyncObjectCategory;
  const SyncObjectCategory._() : super._();

  List<Category> get items;
  @override
  List<SyncItemError> get failedItems;
  @override
  @JsonKey(ignore: true)
  $SyncObjectCategoryCopyWith<SyncObjectCategory> get copyWith =>
      throw _privateConstructorUsedError;
}
