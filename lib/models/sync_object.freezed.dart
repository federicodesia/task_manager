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

  SyncObjectTask task({required List<Task> items}) {
    return SyncObjectTask(
      items: items,
    );
  }

  SyncObjectCategory category({required List<Category> items}) {
    return SyncObjectCategory(
      items: items,
    );
  }
}

/// @nodoc
const $SyncObject = _$SyncObjectTearOff();

/// @nodoc
mixin _$SyncObject {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Task> items) task,
    required TResult Function(List<Category> items) category,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<Task> items)? task,
    TResult Function(List<Category> items)? category,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Task> items)? task,
    TResult Function(List<Category> items)? category,
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
}

/// @nodoc
abstract class $SyncObjectCopyWith<$Res> {
  factory $SyncObjectCopyWith(
          SyncObject value, $Res Function(SyncObject) then) =
      _$SyncObjectCopyWithImpl<$Res>;
}

/// @nodoc
class _$SyncObjectCopyWithImpl<$Res> implements $SyncObjectCopyWith<$Res> {
  _$SyncObjectCopyWithImpl(this._value, this._then);

  final SyncObject _value;
  // ignore: unused_field
  final $Res Function(SyncObject) _then;
}

/// @nodoc
abstract class $SyncObjectTaskCopyWith<$Res> {
  factory $SyncObjectTaskCopyWith(
          SyncObjectTask value, $Res Function(SyncObjectTask) then) =
      _$SyncObjectTaskCopyWithImpl<$Res>;
  $Res call({List<Task> items});
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
  }) {
    return _then(SyncObjectTask(
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Task>,
    ));
  }
}

/// @nodoc

class _$SyncObjectTask extends SyncObjectTask {
  const _$SyncObjectTask({required this.items}) : super._();

  @override
  final List<Task> items;

  @override
  String toString() {
    return 'SyncObject.task(items: $items)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SyncObjectTask &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(items));

  @JsonKey(ignore: true)
  @override
  $SyncObjectTaskCopyWith<SyncObjectTask> get copyWith =>
      _$SyncObjectTaskCopyWithImpl<SyncObjectTask>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Task> items) task,
    required TResult Function(List<Category> items) category,
  }) {
    return task(items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<Task> items)? task,
    TResult Function(List<Category> items)? category,
  }) {
    return task?.call(items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Task> items)? task,
    TResult Function(List<Category> items)? category,
    required TResult orElse(),
  }) {
    if (task != null) {
      return task(items);
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
  const factory SyncObjectTask({required List<Task> items}) = _$SyncObjectTask;
  const SyncObjectTask._() : super._();

  List<Task> get items;
  @JsonKey(ignore: true)
  $SyncObjectTaskCopyWith<SyncObjectTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncObjectCategoryCopyWith<$Res> {
  factory $SyncObjectCategoryCopyWith(
          SyncObjectCategory value, $Res Function(SyncObjectCategory) then) =
      _$SyncObjectCategoryCopyWithImpl<$Res>;
  $Res call({List<Category> items});
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
  }) {
    return _then(SyncObjectCategory(
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }
}

/// @nodoc

class _$SyncObjectCategory extends SyncObjectCategory {
  const _$SyncObjectCategory({required this.items}) : super._();

  @override
  final List<Category> items;

  @override
  String toString() {
    return 'SyncObject.category(items: $items)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SyncObjectCategory &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(items));

  @JsonKey(ignore: true)
  @override
  $SyncObjectCategoryCopyWith<SyncObjectCategory> get copyWith =>
      _$SyncObjectCategoryCopyWithImpl<SyncObjectCategory>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Task> items) task,
    required TResult Function(List<Category> items) category,
  }) {
    return category(items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<Task> items)? task,
    TResult Function(List<Category> items)? category,
  }) {
    return category?.call(items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Task> items)? task,
    TResult Function(List<Category> items)? category,
    required TResult orElse(),
  }) {
    if (category != null) {
      return category(items);
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
  const factory SyncObjectCategory({required List<Category> items}) =
      _$SyncObjectCategory;
  const SyncObjectCategory._() : super._();

  List<Category> get items;
  @JsonKey(ignore: true)
  $SyncObjectCategoryCopyWith<SyncObjectCategory> get copyWith =>
      throw _privateConstructorUsedError;
}
