import 'package:bloc/bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/validators/validators.dart';

class EmailVerificationState {
  final bool isLoading;
  final String? codeError;

  const EmailVerificationState({
    this.isLoading = false,
    this.codeError
  });
}

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  EmailVerificationCubit({
    required this.authRepository,
    required this.authBloc
  }) : super(const EmailVerificationState()){
    sendAccountVerificationCode();
  }

  void submitted({required String code}) async{
    emit(EmailVerificationState(isLoading: true));

    final response = await authRepository.verifyAccountCode(
      authCredentials: authBloc.state.credentials,
      code: code
    );

    response.fold(
      (message) => emit(EmailVerificationState(
        isLoading: false,
        codeError: validateEmailVerificationCode(code) ?? message
      )),

      (verified){
        emit(EmailVerificationState(isLoading: false));
        authBloc.add(AuthEmailVerified());
      }, 
    );
  }

  void sendAccountVerificationCode(){
    authRepository.sendAccountVerificationCode(
      authCredentials: authBloc.state.credentials
    );
  }
}