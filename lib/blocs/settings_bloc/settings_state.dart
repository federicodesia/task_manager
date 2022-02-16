part of 'settings_bloc.dart';

@JsonSerializable()
class SettingsState{

  final ThemeMode themeMode;
  @LocaleSerializer()
  final Locale? locale;

  SettingsState({
    required this.themeMode,
    this.locale
  });

  static SettingsState initial(){
    return SettingsState(
      themeMode: ThemeMode.system
    );
  }

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale
  }){
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale
    );
  }

  factory SettingsState.fromJson(Map<String, dynamic> json) => _$SettingsStateFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);
}