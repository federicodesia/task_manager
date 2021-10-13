import 'package:bloc/bloc.dart';

class AvailableSpaceCubit extends Cubit<double> {
  AvailableSpaceCubit() : super(0);

  void setHeight(double height) => emit(height);
}