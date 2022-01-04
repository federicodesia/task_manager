import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  late StreamSubscription<AuthStatus> _authStatusSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const AuthState.unknown()){

    _authStatusSubscription = _authRepository.status.listen(
      (status) => add(AuthStatusChanged(status)),
    );

    on<AuthStatusChanged>((event, emit){
      switch (event.status) {
        case AuthStatus.unauthenticated:
          return emit(const AuthState.unauthenticated());
        
        case AuthStatus.waitingVerification:
          return emit(AuthState.waitingVerification(User.empty, AuthCredentials.empty));

        case AuthStatus.authenticated:
          return emit(AuthState.authenticated(User.empty, AuthCredentials.empty));

        default:
          return emit(const AuthState.unknown());
      }
    });
  }

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    _authRepository.dispose();
    return super.close();
  }
}