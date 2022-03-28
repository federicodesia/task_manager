import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/validators/validators.dart';

class LoginState {
  final bool isLoading;
  final String? emailError;
  final String? passwordError;

  const LoginState({
    this.isLoading = false,
    this.emailError,
    this.passwordError,
  });
}

class LoginCubit extends Cubit<LoginState> {
  
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  LoginCubit({
    required this.authRepository,
    required this.authBloc
  }) : super(const LoginState());

  void submitted({
    required BuildContext context,
    required String email,
    required String password
  }) async{

    final emailError = Validators.validateEmail(context, email);
    final passwordError = Validators.validatePassword(context, password);

    if(emailError == null && passwordError == null){
      emit(const LoginState(isLoading: true));

      final response = await authRepository.login(
        email: email,
        password: password,
        ignoreKeys: ["user", "email", "password"]
      );

      if(response != null){
        response.when(
          left: (responseMessage) => emit(LoginState(
            isLoading: false,

            emailError: Validators.validateEmailResponse(context, responseMessage)
              ?? (responseMessage.get("user") ?? responseMessage.get("email")),

            passwordError: Validators.validatePasswordResponse(context, responseMessage)
              ?? responseMessage.get("password")
          )),

          right: (authCredentials){
            emit(const LoginState(isLoading: false));
            authBloc.add(AuthCredentialsChanged(authCredentials));
          }, 
        );
      } else {
        emit(const LoginState(isLoading: false));
      }
    }
    else{
      emit(LoginState(
        isLoading: false,
        emailError: emailError,
        passwordError: passwordError,
      ));
    }
  }
}