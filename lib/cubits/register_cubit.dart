import 'package:bloc/bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/helpers/response_messages.dart';
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
    required String name,
    required String email,
    required String password
  }) async{

    emit(RegisterState(isLoading: true));

    final response = await authRepository.register(
      name: name,
      email: email,
      password: password,
      messageKeys: ["name", "email", "password"]
    );

    if(response != null) response.fold(
      (responseMessages) => emit(RegisterState(
        isLoading: false,
        nameError: validateName(name) ?? getResponseMessage(responseMessages, key: "name"),
        emailError: validateEmail(email) ?? getResponseMessage(responseMessages, key: "email"),
        passwordError: validatePassword(password) ?? getResponseMessage(responseMessages, key: "password"),
      )),

      (authCredentials){
        emit(RegisterState(isLoading: false));
        authBloc.add(AuthCredentialsChanged(credentials: authCredentials));
      }, 
    );
    else emit(RegisterState(isLoading: false));
  }
}