import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AuthRepository authRepository;
  final UserRepository userRepository;

  AuthBloc({
    required this.authRepository,
    required this.userRepository
  }) : super(AuthState()){
    
    on<AuthCredentialsChanged>((event, emit) async{
      final credentials = event.credentials;

      emit(state.copyWith(
        credentials: credentials,
        status: credentials.isNotEmpty ? credentials.isVerified
            ? AuthStatus.authenticated
            : AuthStatus.waitingVerification
          : AuthStatus.unauthenticated
      ));

      if(credentials.isVerified){
        final response = await userRepository.getUser(authCredentials: credentials);
        response.fold(
          (_) {},
          (user) => emit(state.copyWith(user: user))
        );
      }
    });

    on<AuthEmailVerified>((event, emit) => emit(state.copyWith(status: AuthStatus.authenticated)));

    on<AuthLogoutRequested>((event, emit){
      authRepository.logout(authCredentials: state.credentials);
      emit(AuthState());
    });
  }
}