part of 'auth_bloc.dart';

class AuthState {

  final AuthStatus status;
  final AuthCredentials credentials;
  final User user;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.credentials = AuthCredentials.empty,
    this.user = User.empty,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(User user, AuthCredentials credentials) : this._(
    status: AuthStatus.authenticated,
    credentials: credentials,
    user: user
  );

  const AuthState.unauthenticated() : this._(
    status: AuthStatus.unauthenticated,
  );
}