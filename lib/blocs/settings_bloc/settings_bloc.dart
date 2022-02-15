import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_event.dart';
part 'settings_state.dart';

part 'settings_bloc.g.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.initial()){

    on<ThemeModeToggled>((event, emit){
      final brightness = Theme.of(event.context).brightness;
      emit(state.copyWith(themeMode: brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark));
    });
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    try{
      print("SettingBloc fromJson");
      return SettingsState.fromJson(json);
    }
    catch(error) {}
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    try{
      print("SettingBloc toJson");
      return state.toJson();
    }
    catch(error) {}
  }
}