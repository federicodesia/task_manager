part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthLoaded extends AuthEvent {}

class AuthCredentialsChanged extends AuthEvent {
  final AuthCredentials credentials;
  AuthCredentialsChanged({required this.credentials});
}

class AuthUserChanged extends AuthEvent {
  final User user;
  AuthUserChanged({required this.user});
}

class AuthLogoutRequested extends AuthEvent {}
class AuthLogoutAllRequested extends AuthEvent {}
class AuthLogoutSessionRequested extends AuthEvent {
  final int sessionId;
  AuthLogoutSessionRequested({required this.sessionId});
}

class UpdateActiveSessionsRequested extends AuthEvent {}