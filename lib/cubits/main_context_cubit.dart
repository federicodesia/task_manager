import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class MainContextCubit extends Cubit<BuildContext> {
  MainContextCubit() : super(null);

  void setContext(BuildContext context) => emit(context);
}