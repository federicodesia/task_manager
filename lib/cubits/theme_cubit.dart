import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark);

  void toggle() => emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
}