import 'package:bloc/bloc.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/validators/validators.dart';

class ForgotPasswordState {
  final bool isLoading;
  final String? emailError;
  final bool emailSent;

  const ForgotPasswordState({
    this.isLoading = false,
    this.emailError,
    this.emailSent = false
  });
}

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  
  final AuthRepository authRepository;

  ForgotPasswordCubit({required this.authRepository})
    : super(const ForgotPasswordState());

  void submitted({required String email}) async{
    emit(ForgotPasswordState(isLoading: true));
    final response = await authRepository.sendPasswordResetCode(email: email);

    if(response != null) response.fold(
      (message){
        final dateTime = DateTime.tryParse(message);
        if(dateTime != null) emit(ForgotPasswordState(emailSent: true));
        else emit(ForgotPasswordState(
          isLoading: false,
          emailError: validateEmail(email) ?? message,
        ));
      },

      (sent) => emit(ForgotPasswordState(emailSent: true))
    );
    else emit(ForgotPasswordState(isLoading: false));
  }
}