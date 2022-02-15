part of 'settings_bloc.dart';

@JsonSerializable()
class SettingsState{

  final ThemeMode themeMode;

  SettingsState({
    required this.themeMode
  });

  static SettingsState initial(){
    return SettingsState(
      themeMode: ThemeMode.system
    );
  }

  SettingsState copyWith({
    ThemeMode? themeMode
  }){
    return SettingsState(
      themeMode: themeMode ?? this.themeMode
    );
  }

  factory SettingsState.fromJson(Map<String, dynamic> json) => _$SettingsStateFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);
}