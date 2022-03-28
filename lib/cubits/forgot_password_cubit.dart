import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/validators/validators.dart';

class ForgotPasswordState {
  final bool isLoading;
  final String? emailError;
  final bool emailSent;

  const ForgotPasswordState({
    this.isLoading = false,
    this.emailError,
    this.emailSent = false
  });
}

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  
  final AuthRepository authRepository;
  ForgotPasswordCubit({
    required this.authRepository
  }) : super(const ForgotPasswordState());

  void submitted({
    required BuildContext context,
    required String email
  }) async{

    final emailError = Validators.validateEmail(context, email);

    if(emailError == null){
      emit(const ForgotPasswordState(isLoading: true));
      final response = await authRepository.sendPasswordResetCode(
        email: email,
        ignoreKeys: ["user", "email"],
        ignoreFunction: (m) => DateTime.tryParse(m.toUpperCase()) != null
      );

      if(response != null) {
        response.when(
          left: (responseMessage){
            final dateTime = DateTime.tryParse(responseMessage.first.toUpperCase());

            if(dateTime != null) {
              emit(const ForgotPasswordState(emailSent: true));
            } else{
              emit(ForgotPasswordState(
                isLoading: false,
                emailError: Validators.validateEmailResponse(context, responseMessage)
                  ?? (responseMessage.get("user") ?? responseMessage.get("email")),
              ));
            }
          },

          right: (sent) => emit(const ForgotPasswordState(emailSent: true))
        );
      } else {
        emit(const ForgotPasswordState(isLoading: false));
      }
    }
    else{
      emit(ForgotPasswordState(
        isLoading: false,
        emailError: emailError,
      ));
    }
  }
}