import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc() : super(AuthState()){
    
    on<AuthCredentialsChanged>((event, emit){
      final credentials = event.credentials;

      emit(state.copyWith(
        credentials: credentials,
        status: credentials.isNotEmpty ? credentials.isVerified
            ? AuthStatus.authenticated
            : AuthStatus.waitingVerification
          : AuthStatus.unauthenticated
      ));
    });
  }
}