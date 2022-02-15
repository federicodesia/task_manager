// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsState _$SettingsStateFromJson(Map<String, dynamic> json) =>
    SettingsState(
      themeMode: $enumDecode(_$ThemeModeEnumMap, json['themeMode']),
    );

Map<String, dynamic> _$SettingsStateToJson(SettingsState instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode],
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
