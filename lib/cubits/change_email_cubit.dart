import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/validators/validators.dart';

class ChangeEmailState {
  final bool isLoading;
  final String? emailError;
  final String? emailConfirmationError;
  final bool emailSent;

  const ChangeEmailState({
    this.isLoading = false,
    this.emailError,
    this.emailConfirmationError,
    this.emailSent = false
  });
}

class ChangeEmailCubit extends Cubit<ChangeEmailState> {
  
  final AuthRepository authRepository;
  final AuthBloc authBloc;
  
  ChangeEmailCubit({
    required this.authRepository,
    required this.authBloc
  }) : super(const ChangeEmailState());

  void submitted({
    required BuildContext context,
    required String email,
    required String emailConfirmation
  }) async{

    final currentEmail = authBloc.state.user?.email;
    if(currentEmail != null){

      final emailError = Validators.validateNewEmail(context, email, currentEmail);
      final emailConfirmationError = Validators.validateNewEmail(context, emailConfirmation, currentEmail)
      ?? Validators.validateEqualEmails(context, email, emailConfirmation);

      if(emailError == null && emailConfirmationError == null){
        emit(const ChangeEmailState(isLoading: true));

        final response = await authRepository.sendChangeEmailCode(
          email: email,
          ignoreKeys: ["email"],
          ignoreFunction: (m) => DateTime.tryParse(m.toUpperCase()) != null
        );

        if(response != null) {
          response.when(
            left: (responseMessage){
              final dateTime = DateTime.tryParse(responseMessage.first.toUpperCase());
              if(dateTime != null) {
                emit(const ChangeEmailState(emailSent: true));
              } else{
                emit(ChangeEmailState(
                  isLoading: false,
                  emailError: Validators.validateEmailResponse(context, responseMessage)
                    ?? responseMessage.get("email"),
                ));
              }
            },

            right: (sent){
              emit(const ChangeEmailState(emailSent: true));
            }, 
          );
        } else {
          emit(const ChangeEmailState(isLoading: false));
        }
      }
      else{
        emit(ChangeEmailState(
          isLoading: false,
          emailError: emailError,
          emailConfirmationError: emailConfirmationError
        ));
      }
    }
  }
}