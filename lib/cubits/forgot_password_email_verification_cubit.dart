import 'package:bloc/bloc.dart';
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

  void submitted({required String code}) async{
    emit(ForgotPasswordEmailVerificationState(isLoading: true));

    final response = await authRepository.verifyPasswordCode(
      email: email,
      code: code
    );

    if(response != null) response.when(
      left: (message) => emit(ForgotPasswordEmailVerificationState(
        isLoading: false,
        codeError: validateEmailVerificationCode(code) ?? message
      )),

      right: (credentials){
        emit(ForgotPasswordEmailVerificationState(verified: true));
        authBloc.add(AuthCredentialsChanged(credentials: credentials));
      }, 
    );
    else emit(ForgotPasswordEmailVerificationState(isLoading: false));
  }

  void sendPasswordResetCode(){
    authRepository.sendPasswordResetCode(
      email: email
    );
  }
}