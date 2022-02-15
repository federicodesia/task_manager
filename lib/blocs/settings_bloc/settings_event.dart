part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class ThemeModeToggled extends SettingsEvent {
  final BuildContext context;
  ThemeModeToggled(this.context);
}