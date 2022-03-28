import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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
  ChangePasswordCubit({
    required this.authRepository
  }) : super(const ChangePasswordState());

  void submitted({
    required BuildContext context,
    required String currentPassword,
    required String newPassword
  }) async{

    final currentPasswordError = Validators.validateCurrentPassword(context, currentPassword);
    final newPasswordError = Validators.validateNewPassword(context, currentPassword, newPassword);

    if(currentPasswordError == null && newPasswordError == null){
      emit(const ChangePasswordState(isLoading: true));

      final response = await authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        ignoreKeys: ["password"]
      );

      if(response != null) {
        response.when(
          left: (responseMessage) => emit(ChangePasswordState(
            isLoading: false,
            currentPasswordError: Validators.validatePasswordResponse(context, responseMessage)
              ?? responseMessage.getIgnoring("password", ignore: "newPassword"),
            newPasswordError: responseMessage.get("newPassword")
          )),

          right: (changed){
            emit(const ChangePasswordState(changed: true));
          },
        );
      } else {
        emit(const ChangePasswordState(isLoading: false));
      }
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