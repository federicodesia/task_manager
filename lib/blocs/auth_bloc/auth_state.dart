part of 'auth_bloc.dart';

enum AuthStatus { unknown, waitingVerification, authenticated, unauthenticated }

class AuthState {

  final AuthStatus? status;
  final AuthCredentials? credentials;
  final User? user;

  AuthState({
    this.status = AuthStatus.unknown,
    this.credentials,
    this.user,
  });

  AuthState copyWith({
    required AuthState newState
  }){
    return AuthState(
      status: newState.status ?? this.status,
      credentials: newState.credentials ?? this.credentials,
      user: newState.user ?? this.user
    );
  }
}