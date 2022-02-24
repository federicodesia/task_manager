import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/validators/validators.dart';

class ChangePasswordState {
  final bool isLoading;
  final String? currentPasswordError;
  final String? newPasswordError;
  final bool changed;

  const ChangePasswordState({
    this.isLoading = false,
    this.currentPasswordError,
    this.newPasswordError,
    this.changed = false
  });
}

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  ChangePasswordCubit({
    required this.authRepository,
    required this.authBloc
  }) : super(const ChangePasswordState());

  void submitted({
    required BuildContext context,
    required String currentPassword,
    required String newPassword
  }) async{

    final currentPasswordError = Validators.validatePassword(context, currentPassword);
    final newPasswordError = Validators.validatePassword(context, newPassword);

    if(currentPasswordError == null && newPasswordError == null){
      emit(ChangePasswordState(isLoading: true));

      final response = await authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        ignoreKeys: ["password"]
      );

      if(response != null) response.when(
        left: (responseMessage) => emit(ChangePasswordState(
          isLoading: false,
          currentPasswordError: Validators.validatePasswordResponse(context, responseMessage)
            ?? responseMessage.getIgnoring("password", ignore: "new password"),
          newPasswordError: responseMessage.get("new password")
        )),

        right: (changed){
          emit(ChangePasswordState(changed: true));
        }, 
      );
      else emit(ChangePasswordState(isLoading: false));
    }
    else{
      emit(ChangePasswordState(
        isLoading: false,
        currentPasswordError: currentPasswordError,
        newPasswordError: newPasswordError
      ));
    }
  }
}