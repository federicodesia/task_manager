// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'notification_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NotificationType _$NotificationTypeFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'general':
      return GeneralNotification.fromJson(json);
    case 'reminder':
      return ReminderNotification.fromJson(json);
    case 'security':
      return SecurityNotification.fromJson(json);
    case 'advertisement':
      return AdvertisementNotification.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'NotificationType',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
class _$NotificationTypeTearOff {
  const _$NotificationTypeTearOff();

  GeneralNotification general(
      {@ColorSerializer() Color color = const Color(0xFF008FFD)}) {
    return GeneralNotification(
      color: color,
    );
  }

  ReminderNotification reminder(
      {@ColorSerializer() Color color = const Color(0xFF5C5D9D)}) {
    return ReminderNotification(
      color: color,
    );
  }

  SecurityNotification security(
      {@ColorSerializer() Color color = const Color(0xFFFF8700)}) {
    return SecurityNotification(
      color: color,
    );
  }

  AdvertisementNotification advertisement(
      {@ColorSerializer() Color color = const Color(0xFFFFBF47)}) {
    return AdvertisementNotification(
      color: color,
    );
  }

  NotificationType fromJson(Map<String, Object?> json) {
    return NotificationType.fromJson(json);
  }
}

/// @nodoc
const $NotificationType = _$NotificationTypeTearOff();

/// @nodoc
mixin _$NotificationType {
  @ColorSerializer()
  Color get color => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@ColorSerializer() Color color) general,
    required TResult Function(@ColorSerializer() Color color) reminder,
    required TResult Function(@ColorSerializer() Color color) security,
    required TResult Function(@ColorSerializer() Color color) advertisement,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(@ColorSerializer() Color color)? general,
    TResult Function(@ColorSerializer() Color color)? reminder,
    TResult Function(@ColorSerializer() Color color)? security,
    TResult Function(@ColorSerializer() Color color)? advertisement,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@ColorSerializer() Color color)? general,
    TResult Function(@ColorSerializer() Color color)? reminder,
    TResult Function(@ColorSerializer() Color color)? security,
    TResult Function(@ColorSerializer() Color color)? advertisement,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GeneralNotification value) general,
    required TResult Function(ReminderNotification value) reminder,
    required TResult Function(SecurityNotification value) security,
    required TResult Function(AdvertisementNotification value) advertisement,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(GeneralNotification value)? general,
    TResult Function(ReminderNotification value)? reminder,
    TResult Function(SecurityNotification value)? security,
    TResult Function(AdvertisementNotification value)? advertisement,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GeneralNotification value)? general,
    TResult Function(ReminderNotification value)? reminder,
    TResult Function(SecurityNotification value)? security,
    TResult Function(AdvertisementNotification value)? advertisement,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationTypeCopyWith<NotificationType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationTypeCopyWith<$Res> {
  factory $NotificationTypeCopyWith(
          NotificationType value, $Res Function(NotificationType) then) =
      _$NotificationTypeCopyWithImpl<$Res>;
  $Res call({@ColorSerializer() Color color});
}

/// @nodoc
class _$NotificationTypeCopyWithImpl<$Res>
    implements $NotificationTypeCopyWith<$Res> {
  _$NotificationTypeCopyWithImpl(this._value, this._then);

  final NotificationType _value;
  // ignore: unused_field
  final $Res Function(NotificationType) _then;

  @override
  $Res call({
    Object? color = freezed,
  }) {
    return _then(_value.copyWith(
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc
abstract class $GeneralNotificationCopyWith<$Res>
    implements $NotificationTypeCopyWith<$Res> {
  factory $GeneralNotificationCopyWith(
          GeneralNotification value, $Res Function(GeneralNotification) then) =
      _$GeneralNotificationCopyWithImpl<$Res>;
  @override
  $Res call({@ColorSerializer() Color color});
}

/// @nodoc
class _$GeneralNotificationCopyWithImpl<$Res>
    extends _$NotificationTypeCopyWithImpl<$Res>
    implements $GeneralNotificationCopyWith<$Res> {
  _$GeneralNotificationCopyWithImpl(
      GeneralNotification _value, $Res Function(GeneralNotification) _then)
      : super(_value, (v) => _then(v as GeneralNotification));

  @override
  GeneralNotification get _value => super._value as GeneralNotification;

  @override
  $Res call({
    Object? color = freezed,
  }) {
    return _then(GeneralNotification(
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeneralNotification implements GeneralNotification {
  const _$GeneralNotification(
      {@ColorSerializer() this.color = const Color(0xFF008FFD), String? $type})
      : $type = $type ?? 'general';

  factory _$GeneralNotification.fromJson(Map<String, dynamic> json) =>
      _$$GeneralNotificationFromJson(json);

  @JsonKey()
  @override
  @ColorSerializer()
  final Color color;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'NotificationType.general(color: $color)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GeneralNotification &&
            const DeepCollectionEquality().equals(other.color, color));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(color));

  @JsonKey(ignore: true)
  @override
  $GeneralNotificationCopyWith<GeneralNotification> get copyWith =>
      _$GeneralNotificationCopyWithImpl<GeneralNotification>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@ColorSerializer() Color color) general,
    required TResult Function(@ColorSerializer() Color color) reminder,
    required TResult Function(@ColorSerializer() Color color) security,
    required TResult Function(@ColorSerializer() Color color) advertisement,
  }) {
    return general(color);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(@ColorSerializer() Color color)? general,
    TResult Function(@ColorSerializer() Color color)? reminder,
    TResult Function(@ColorSerializer() Color color)? security,
    TResult Function(@ColorSerializer() Color color)? advertisement,
  }) {
    return general?.call(color);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@ColorSerializer() Color color)? general,
    TResult Function(@ColorSerializer() Color color)? reminder,
    TResult Function(@ColorSerializer() Color color)? security,
    TResult Function(@ColorSerializer() Color color)? advertisement,
    required TResult orElse(),
  }) {
    if (general != null) {
      return general(color);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GeneralNotification value) general,
    required TResult Function(ReminderNotification value) reminder,
    required TResult Function(SecurityNotification value) security,
    required TResult Function(AdvertisementNotification value) advertisement,
  }) {
    return general(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(GeneralNotification value)? general,
    TResult Function(ReminderNotification value)? reminder,
    TResult Function(SecurityNotification value)? security,
    TResult Function(AdvertisementNotification value)? advertisement,
  }) {
    return general?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GeneralNotification value)? general,
    TResult Function(ReminderNotification value)? reminder,
    TResult Function(SecurityNotification value)? security,
    TResult Function(AdvertisementNotification value)? advertisement,
    required TResult orElse(),
  }) {
    if (general != null) {
      return general(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GeneralNotificationToJson(this);
  }
}

abstract class GeneralNotification implements NotificationType {
  const factory GeneralNotification({@ColorSerializer() Color color}) =
      _$GeneralNotification;

  factory GeneralNotification.fromJson(Map<String, dynamic> json) =
      _$GeneralNotification.fromJson;

  @override
  @ColorSerializer()
  Color get color;
  @override
  @JsonKey(ignore: true)
  $GeneralNotificationCopyWith<GeneralNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderNotificationCopyWith<$Res>
    implements $NotificationTypeCopyWith<$Res> {
  factory $ReminderNotificationCopyWith(ReminderNotification value,
          $Res Function(ReminderNotification) then) =
      _$ReminderNotificationCopyWithImpl<$Res>;
  @override
  $Res call({@ColorSerializer() Color color});
}

/// @nodoc
class _$ReminderNotificationCopyWithImpl<$Res>
    extends _$NotificationTypeCopyWithImpl<$Res>
    implements $ReminderNotificationCopyWith<$Res> {
  _$ReminderNotificationCopyWithImpl(
      ReminderNotification _value, $Res Function(ReminderNotification) _then)
      : super(_value, (v) => _then(v as ReminderNotification));

  @override
  ReminderNotification get _value => super._value as ReminderNotification;

  @override
  $Res call({
    Object? color = freezed,
  }) {
    return _then(ReminderNotification(
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReminderNotification implements ReminderNotification {
  const _$ReminderNotification(
      {@ColorSerializer() this.color = const Color(0xFF5C5D9D), String? $type})
      : $type = $type ?? 'reminder';

  factory _$ReminderNotification.fromJson(Map<String, dynamic> json) =>
      _$$ReminderNotificationFromJson(json);

  @JsonKey()
  @override
  @ColorSerializer()
  final Color color;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'NotificationType.reminder(color: $color)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReminderNotification &&
            const DeepCollectionEquality().equals(other.color, color));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(color));

  @JsonKey(ignore: true)
  @override
  $ReminderNotificationCopyWith<ReminderNotification> get copyWith =>
      _$ReminderNotificationCopyWithImpl<ReminderNotification>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@ColorSerializer() Color color) general,
    required TResult Function(@ColorSerializer() Color color) reminder,
    required TResult Function(@ColorSerializer() Color color) security,
    required TResult Function(@ColorSerializer() Color color) advertisement,
  }) {
    return reminder(color);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(@ColorSerializer() Color color)? general,
    TResult Function(@ColorSerializer() Color color)? reminder,
    TResult Function(@ColorSerializer() Color color)? security,
    TResult Function(@ColorSerializer() Color color)? advertisement,
  }) {
    return reminder?.call(color);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@ColorSerializer() Color color)? general,
    TResult Function(@ColorSerializer() Color color)? reminder,
    TResult Function(@ColorSerializer() Color color)? security,
    TResult Function(@ColorSerializer() Color color)? advertisement,
    required TResult orElse(),
  }) {
    if (reminder != null) {
      return reminder(color);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GeneralNotification value) general,
    required TResult Function(ReminderNotification value) reminder,
    required TResult Function(SecurityNotification value) security,
    required TResult Function(AdvertisementNotification value) advertisement,
  }) {
    return reminder(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(GeneralNotification value)? general,
    TResult Function(ReminderNotification value)? reminder,
    TResult Function(SecurityNotification value)? security,
    TResult Function(AdvertisementNotification value)? advertisement,
  }) {
    return reminder?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GeneralNotification value)? general,
    TResult Function(ReminderNotification value)? reminder,
    TResult Function(SecurityNotification value)? security,
    TResult Function(AdvertisementNotification value)? advertisement,
    required TResult orElse(),
  }) {
    if (reminder != null) {
      return reminder(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderNotificationToJson(this);
  }
}

abstract class ReminderNotification implements NotificationType {
  const factory ReminderNotification({@ColorSerializer() Color color}) =
      _$ReminderNotification;

  factory ReminderNotification.fromJson(Map<String, dynamic> json) =
      _$ReminderNotification.fromJson;

  @override
  @ColorSerializer()
  Color get color;
  @override
  @JsonKey(ignore: true)
  $ReminderNotificationCopyWith<ReminderNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecurityNotificationCopyWith<$Res>
    implements $NotificationTypeCopyWith<$Res> {
  factory $SecurityNotificationCopyWith(SecurityNotification value,
          $Res Function(SecurityNotification) then) =
      _$SecurityNotificationCopyWithImpl<$Res>;
  @override
  $Res call({@ColorSerializer() Color color});
}

/// @nodoc
class _$SecurityNotificationCopyWithImpl<$Res>
    extends _$NotificationTypeCopyWithImpl<$Res>
    implements $SecurityNotificationCopyWith<$Res> {
  _$SecurityNotificationCopyWithImpl(
      SecurityNotification _value, $Res Function(SecurityNotification) _then)
      : super(_value, (v) => _then(v as SecurityNotification));

  @override
  SecurityNotification get _value => super._value as SecurityNotification;

  @override
  $Res call({
    Object? color = freezed,
  }) {
    return _then(SecurityNotification(
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SecurityNotification implements SecurityNotification {
  const _$SecurityNotification(
      {@ColorSerializer() this.color = const Color(0xFFFF8700), String? $type})
      : $type = $type ?? 'security';

  factory _$SecurityNotification.fromJson(Map<String, dynamic> json) =>
      _$$SecurityNotificationFromJson(json);

  @JsonKey()
  @override
  @ColorSerializer()
  final Color color;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'NotificationType.security(color: $color)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SecurityNotification &&
            const DeepCollectionEquality().equals(other.color, color));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(color));

  @JsonKey(ignore: true)
  @override
  $SecurityNotificationCopyWith<SecurityNotification> get copyWith =>
      _$SecurityNotificationCopyWithImpl<SecurityNotification>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@ColorSerializer() Color color) general,
    required TResult Function(@ColorSerializer() Color color) reminder,
    required TResult Function(@ColorSerializer() Color color) security,
    required TResult Function(@ColorSerializer() Color color) advertisement,
  }) {
    return security(color);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(@ColorSerializer() Color color)? general,
    TResult Function(@ColorSerializer() Color color)? reminder,
    TResult Function(@ColorSerializer() Color color)? security,
    TResult Function(@ColorSerializer() Color color)? advertisement,
  }) {
    return security?.call(color);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@ColorSerializer() Color color)? general,
    TResult Function(@ColorSerializer() Color color)? reminder,
    TResult Function(@ColorSerializer() Color color)? security,
    TResult Function(@ColorSerializer() Color color)? advertisement,
    required TResult orElse(),
  }) {
    if (security != null) {
      return security(color);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GeneralNotification value) general,
    required TResult Function(ReminderNotification value) reminder,
    required TResult Function(SecurityNotification value) security,
    required TResult Function(AdvertisementNotification value) advertisement,
  }) {
    return security(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(GeneralNotification value)? general,
    TResult Function(ReminderNotification value)? reminder,
    TResult Function(SecurityNotification value)? security,
    TResult Function(AdvertisementNotification value)? advertisement,
  }) {
    return security?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GeneralNotification value)? general,
    TResult Function(ReminderNotification value)? reminder,
    TResult Function(SecurityNotification value)? security,
    TResult Function(AdvertisementNotification value)? advertisement,
    required TResult orElse(),
  }) {
    if (security != null) {
      return security(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SecurityNotificationToJson(this);
  }
}

abstract class SecurityNotification implements NotificationType {
  const factory SecurityNotification({@ColorSerializer() Color color}) =
      _$SecurityNotification;

  factory SecurityNotification.fromJson(Map<String, dynamic> json) =
      _$SecurityNotification.fromJson;

  @override
  @ColorSerializer()
  Color get color;
  @override
  @JsonKey(ignore: true)
  $SecurityNotificationCopyWith<SecurityNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdvertisementNotificationCopyWith<$Res>
    implements $NotificationTypeCopyWith<$Res> {
  factory $AdvertisementNotificationCopyWith(AdvertisementNotification value,
          $Res Function(AdvertisementNotification) then) =
      _$AdvertisementNotificationCopyWithImpl<$Res>;
  @override
  $Res call({@ColorSerializer() Color color});
}

/// @nodoc
class _$AdvertisementNotificationCopyWithImpl<$Res>
    extends _$NotificationTypeCopyWithImpl<$Res>
    implements $AdvertisementNotificationCopyWith<$Res> {
  _$AdvertisementNotificationCopyWithImpl(AdvertisementNotification _value,
      $Res Function(AdvertisementNotification) _then)
      : super(_value, (v) => _then(v as AdvertisementNotification));

  @override
  AdvertisementNotification get _value =>
      super._value as AdvertisementNotification;

  @override
  $Res call({
    Object? color = freezed,
  }) {
    return _then(AdvertisementNotification(
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdvertisementNotification implements AdvertisementNotification {
  const _$AdvertisementNotification(
      {@ColorSerializer() this.color = const Color(0xFFFFBF47), String? $type})
      : $type = $type ?? 'advertisement';

  factory _$AdvertisementNotification.fromJson(Map<String, dynamic> json) =>
      _$$AdvertisementNotificationFromJson(json);

  @JsonKey()
  @override
  @ColorSerializer()
  final Color color;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'NotificationType.advertisement(color: $color)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdvertisementNotification &&
            const DeepCollectionEquality().equals(other.color, color));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(color));

  @JsonKey(ignore: true)
  @override
  $AdvertisementNotificationCopyWith<AdvertisementNotification> get copyWith =>
      _$AdvertisementNotificationCopyWithImpl<AdvertisementNotification>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@ColorSerializer() Color color) general,
    required TResult Function(@ColorSerializer() Color color) reminder,
    required TResult Function(@ColorSerializer() Color color) security,
    required TResult Function(@ColorSerializer() Color color) advertisement,
  }) {
    return advertisement(color);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(@ColorSerializer() Color color)? general,
    TResult Function(@ColorSerializer() Color color)? reminder,
    TResult Function(@ColorSerializer() Color color)? security,
    TResult Function(@ColorSerializer() Color color)? advertisement,
  }) {
    return advertisement?.call(color);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@ColorSerializer() Color color)? general,
    TResult Function(@ColorSerializer() Color color)? reminder,
    TResult Function(@ColorSerializer() Color color)? security,
    TResult Function(@ColorSerializer() Color color)? advertisement,
    required TResult orElse(),
  }) {
    if (advertisement != null) {
      return advertisement(color);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GeneralNotification value) general,
    required TResult Function(ReminderNotification value) reminder,
    required TResult Function(SecurityNotification value) security,
    required TResult Function(AdvertisementNotification value) advertisement,
  }) {
    return advertisement(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(GeneralNotification value)? general,
    TResult Function(ReminderNotification value)? reminder,
    TResult Function(SecurityNotification value)? security,
    TResult Function(AdvertisementNotification value)? advertisement,
  }) {
    return advertisement?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GeneralNotification value)? general,
    TResult Function(ReminderNotification value)? reminder,
    TResult Function(SecurityNotification value)? security,
    TResult Function(AdvertisementNotification value)? advertisement,
    required TResult orElse(),
  }) {
    if (advertisement != null) {
      return advertisement(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AdvertisementNotificationToJson(this);
  }
}

abstract class AdvertisementNotification implements NotificationType {
  const factory AdvertisementNotification({@ColorSerializer() Color color}) =
      _$AdvertisementNotification;

  factory AdvertisementNotification.fromJson(Map<String, dynamic> json) =
      _$AdvertisementNotification.fromJson;

  @override
  @ColorSerializer()
  Color get color;
  @override
  @JsonKey(ignore: true)
  $AdvertisementNotificationCopyWith<AdvertisementNotification> get copyWith =>
      throw _privateConstructorUsedError;
}
