import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/validators/validators.dart';

class ForgotPasswordNewPasswordState {
  final bool isLoading;
  final String? passwordError;
  final bool changed;

  const ForgotPasswordNewPasswordState({
    this.isLoading = false,
    this.passwordError,
    this.changed = false
  });
}

class ForgotPasswordNewPasswordCubit extends Cubit<ForgotPasswordNewPasswordState> {
  
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  ForgotPasswordNewPasswordCubit({
    required this.authRepository,
    required this.authBloc
  }) : super(const ForgotPasswordNewPasswordState());

  void submitted({
    required BuildContext context,
    required String password
  }) async{

    final passwordError = Validators.validatePassword(context, password);

    if(passwordError == null){
      emit(const ForgotPasswordNewPasswordState(isLoading: true));

      final response = await authRepository.changeForgotPassword(
        password: password,
        ignoreKeys: ["password"]
      );

      if(response != null) {
        response.when(
          left: (responseMessage) => emit(ForgotPasswordNewPasswordState(
            isLoading: false,
            passwordError: Validators.validatePasswordResponse(context, responseMessage)
              ?? responseMessage.get("password")
          )),

          right: (changed){
            emit(const ForgotPasswordNewPasswordState(changed: true));
            authBloc.add(AuthCredentialsChanged(AuthCredentials.empty));
          }, 
        );
      } else {
        emit(const ForgotPasswordNewPasswordState(isLoading: false));
      }
    }
    else{
      emit(ForgotPasswordNewPasswordState(
        isLoading: false,
        passwordError: passwordError,
      ));
    }
  }
}