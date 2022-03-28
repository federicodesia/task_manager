import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/validators/validators.dart';

class ChangeEmailVerificationState {
  final bool isLoading;
  final String? codeError;
  final bool changed;

  const ChangeEmailVerificationState({
    this.isLoading = false,
    this.codeError,
    this.changed = false
  });
}

class ChangeEmailVerificationCubit extends Cubit<ChangeEmailVerificationState> {
  
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  ChangeEmailVerificationCubit({
    required this.authRepository,
    required this.authBloc
  }) : super(const ChangeEmailVerificationState());

  void submitted({
    required BuildContext context,
    required String code
  }) async{

    final codeError = Validators.validateEmailVerificationCode(context, code);

    if(codeError == null){
      emit(const ChangeEmailVerificationState(isLoading: true));

      final response = await authRepository.verifyChangeEmailCode(
        code: code,
        ignoreKeys: ["code"]
      );

      if(response != null) {
        response.when(
          left: (responseMessage){
            emit(ChangeEmailVerificationState(
              isLoading: false,
              codeError: Validators.validateEmailVerificationCodeResponse(context, responseMessage)
                ?? responseMessage.get("code"),
            ));
          },

          right: (user){
            authBloc.add(AuthUserChanged(user));
            emit(const ChangeEmailVerificationState(changed: true));
          }, 
        );
      } else {
        emit(const ChangeEmailVerificationState(isLoading: false));
      }
    }
    else{
      emit(ChangeEmailVerificationState(
        isLoading: false,
        codeError: codeError
      ));
    }
  }
}