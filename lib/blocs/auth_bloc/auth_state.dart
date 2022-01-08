part of 'auth_bloc.dart';

enum AuthStatus { loading, unauthenticated, waitingVerification, authenticated }

class AuthState {

  final AuthStatus status;
  final AuthCredentials credentials;
  final User user;

  AuthState({
    this.status = AuthStatus.unauthenticated,
    this.credentials = AuthCredentials.empty,
    this.user = User.empty
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthCredentials? credentials,
    User? user
  }){
    return AuthState(
      status: status ?? this.status,
      credentials: credentials ?? this.credentials,
      user: user ?? this.user
    );
  }
}