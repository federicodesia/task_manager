import 'package:bloc/bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/helpers/response_messages.dart';
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
    required String email,
    required String password
  }) async{

    emit(LoginState(isLoading: true));

    final response = await authRepository.login(
      email: email,
      password: password,
      messageKeys: ["email", "password"]
    );

    if(response != null){
      response.fold(
        (responseMessages) => emit(LoginState(
          isLoading: false,
          emailError: validateEmail(email) ?? getResponseMessage(responseMessages, key: "email"),
          passwordError: validatePassword(password) ?? getResponseMessage(responseMessages, key: "password"),
        )),

        (authCredentials){
          emit(LoginState(isLoading: false));
          authBloc.add(AuthCredentialsChanged(credentials: authCredentials));
        }, 
      );
    } else emit(LoginState(isLoading: false));
  }
}