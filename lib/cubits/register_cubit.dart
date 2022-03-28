import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/validators/validators.dart';

class RegisterState {
  final bool isLoading;
  final String? nameError;
  final String? emailError;
  final String? passwordError;

  const RegisterState({
    this.isLoading = false,
    this.nameError,
    this.emailError,
    this.passwordError,
  });
}

class RegisterCubit extends Cubit<RegisterState> {
  
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  RegisterCubit({
    required this.authRepository,
    required this.authBloc
  }) : super(const RegisterState());

  void submitted({
    required BuildContext context,
    required String name,
    required String email,
    required String password
  }) async{

    final nameError = Validators.validateName(context, name);
    final emailError = Validators.validateEmail(context, email);
    final passwordError = Validators.validatePassword(context, password);

    if(nameError == null && emailError == null && passwordError == null){
      emit(const RegisterState(isLoading: true));

      final response = await authRepository.register(
        name: name,
        email: email,
        password: password,
        ignoreKeys: ["name", "user", "email", "password"]
      );

      if(response != null) {
        response.when(
          left: (responseMessage) => emit(RegisterState(
            isLoading: false,
            nameError: responseMessage.get("name"),
            emailError: Validators.validateEmailResponse(context, responseMessage)
                ?? (responseMessage.get("user") ?? responseMessage.get("email")),
            passwordError: responseMessage.get("password"),
          )),

          right: (authCredentials){
            emit(const RegisterState(isLoading: false));
            authBloc.add(AuthCredentialsChanged(authCredentials));
          }, 
        );
      } else {
        emit(const RegisterState(isLoading: false));
      }
    }
    else{
      emit(RegisterState(
        isLoading: false,
        nameError: nameError,
        emailError: emailError,
        passwordError: passwordError,
      ));
    }
  }
}