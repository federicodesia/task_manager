import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
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

  void submitted({
    required BuildContext context,
    required String code
  }) async{

    final codeError = Validators.validateEmailVerificationCode(context, code);

    if(codeError == null){
      emit(const EmailVerificationState(isLoading: true));

      final response = await authRepository.verifyAccountCode(
        code: code,
        ignoreKeys: ["code"]
      );

      if(response != null) {
        response.when(
          left: (responseMessage) => emit(EmailVerificationState(
            isLoading: false,
            codeError: Validators.validateEmailVerificationCodeResponse(context, responseMessage)
              ?? responseMessage.get("code"),
          )),

          right: (accessToken) async {
            emit(const EmailVerificationState(isLoading: false));
            final currentCredentials = await authBloc.secureStorageRepository.read.authCredentials;
            authBloc.add(AuthCredentialsChanged(currentCredentials.copyWith(accessToken: accessToken)));
          }, 
        );
      } else {
        emit(const EmailVerificationState(isLoading: false));
      }
    }
    else{
      emit(EmailVerificationState(
        isLoading: false,
        codeError: codeError,
      ));
    }
  }

  void sendAccountVerificationCode(){
    authRepository.sendAccountVerificationCode(
      ignoreFunction: (m) => DateTime.tryParse(m.toUpperCase()) != null
    );
  }
}