part of 'settings_cubit.dart';

@JsonSerializable()
class SettingsState{

  final ThemeMode themeMode;
  @LocaleSerializer()
  final Locale? locale;

  final bool beforeScheduleNotification;
  final bool taskScheduleNotification;
  final bool uncompletedTaskNotification;
  final bool newUpdatesAvailableNotification;
  final bool announcementsAndOffersNotification;
  final bool loginOnNewDeviceNotification;

  SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale,
    this.beforeScheduleNotification = true,
    this.taskScheduleNotification = true,
    this.uncompletedTaskNotification = true,
    this.newUpdatesAvailableNotification = true,
    this.announcementsAndOffersNotification = true,
    this.loginOnNewDeviceNotification = true
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? beforeScheduleNotification,
    bool? taskScheduleNotification,
    bool? uncompletedTaskNotification,
    bool? newUpdatesAvailableNotification,
    bool? announcementsAndOffersNotification,
    bool? loginOnNewDeviceNotification,
  }){
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      beforeScheduleNotification: beforeScheduleNotification ?? this.beforeScheduleNotification,
      taskScheduleNotification: taskScheduleNotification ?? this.taskScheduleNotification,
      uncompletedTaskNotification: uncompletedTaskNotification ?? this.uncompletedTaskNotification,
      newUpdatesAvailableNotification: newUpdatesAvailableNotification ?? this.newUpdatesAvailableNotification,
      announcementsAndOffersNotification: announcementsAndOffersNotification ?? this.announcementsAndOffersNotification,
      loginOnNewDeviceNotification: loginOnNewDeviceNotification ?? this.loginOnNewDeviceNotification
    );
  }

  factory SettingsState.fromJson(Map<String, dynamic> json) => _$SettingsStateFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);
}