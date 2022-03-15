// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsState _$SettingsStateFromJson(Map<String, dynamic> json) =>
    SettingsState(
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      locale: const LocaleSerializer().fromJson(json['locale'] as String?),
      beforeScheduleNotification:
          json['beforeScheduleNotification'] as bool? ?? true,
      taskScheduleNotification:
          json['taskScheduleNotification'] as bool? ?? true,
      uncompletedTaskNotification:
          json['uncompletedTaskNotification'] as bool? ?? true,
      newUpdatesAvailableNotification:
          json['newUpdatesAvailableNotification'] as bool? ?? true,
      announcementsAndOffersNotification:
          json['announcementsAndOffersNotification'] as bool? ?? true,
      loginOnNewDeviceNotification:
          json['loginOnNewDeviceNotification'] as bool? ?? true,
    );

Map<String, dynamic> _$SettingsStateToJson(SettingsState instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode],
      'locale': const LocaleSerializer().toJson(instance.locale),
      'beforeScheduleNotification': instance.beforeScheduleNotification,
      'taskScheduleNotification': instance.taskScheduleNotification,
      'uncompletedTaskNotification': instance.uncompletedTaskNotification,
      'newUpdatesAvailableNotification':
          instance.newUpdatesAvailableNotification,
      'announcementsAndOffersNotification':
          instance.announcementsAndOffersNotification,
      'loginOnNewDeviceNotification': instance.loginOnNewDeviceNotification,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
