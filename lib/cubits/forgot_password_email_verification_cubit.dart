import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/validators/validators.dart';

class ForgotPasswordEmailVerificationState {
  final bool isLoading;
  final String? codeError;
  final bool verified;

  const ForgotPasswordEmailVerificationState({
    this.isLoading = false,
    this.codeError,
    this.verified = false
  });
}

class ForgotPasswordEmailVerificationCubit extends Cubit<ForgotPasswordEmailVerificationState> {
  
  final AuthRepository authRepository;
  final AuthBloc authBloc;
  final String email;

  ForgotPasswordEmailVerificationCubit({
    required this.authRepository,
    required this.authBloc,
    required this.email
  }) : super(const ForgotPasswordEmailVerificationState());

  void submitted({
    required BuildContext context,
    required String code
  }) async{

    final codeError = Validators.validateEmailVerificationCode(context, code);

    if(codeError == null){
      emit(const ForgotPasswordEmailVerificationState(isLoading: true));

      final response = await authRepository.verifyPasswordCode(
        email: email,
        code: code,
        ignoreKeys: ["code"]
      );

      if(response != null) {
        response.when(
          left: (responseMessage) => emit(ForgotPasswordEmailVerificationState(
            isLoading: false,
            codeError: Validators.validateEmailVerificationCodeResponse(context, responseMessage)
              ?? responseMessage.get("code"),
          )),

          right: (credentials){
            emit(const ForgotPasswordEmailVerificationState(verified: true));
            authBloc.add(AuthCredentialsChanged(credentials));
          }, 
        );
      } else {
        emit(const ForgotPasswordEmailVerificationState(isLoading: false));
      }
    }
    else{
      emit(ForgotPasswordEmailVerificationState(
        isLoading: false,
        codeError: codeError,
      ));
    }
  }

  void sendPasswordResetCode(){
    authRepository.sendPasswordResetCode(
      email: email
    );
  }
}