part of 'register_bloc.dart';

class RegisterState {

  final String? nameError;
  final String? emailError;
  final String? passwordError;

  const RegisterState({
    this.nameError,
    this.emailError,
    this.passwordError,
  });

  bool get isValid =>
    nameError == null
    && emailError == null
    && passwordError == null;

  RegisterState copyWith({
    String? nameError = "",
    String? emailError = "",
    String? passwordError = "",
  }) {
    return RegisterState(
      nameError: nameError ?? this.nameError,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
    );
  }
}