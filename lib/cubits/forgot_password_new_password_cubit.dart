import 'package:bloc/bloc.dart';
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

  void submitted({required String password}) async{
    emit(ForgotPasswordNewPasswordState(isLoading: true));

    final response = await authRepository.changeForgotPassword(
      credentials: authBloc.state.credentials,
      password: password
    );

    if(response != null) response.fold(
      (message) => emit(ForgotPasswordNewPasswordState(
        isLoading: false,
        passwordError: validatePassword(password) ?? message
      )),

      (changed){
        emit(ForgotPasswordNewPasswordState(changed: true));
        authBloc.add(AuthCredentialsChanged(credentials: AuthCredentials.empty));
      }, 
    );
    else emit(ForgotPasswordNewPasswordState(isLoading: false));
  }
}