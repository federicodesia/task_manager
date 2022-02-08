part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthLoaded extends AuthEvent {}

class AuthCredentialsChanged extends AuthEvent {
  final AuthCredentials credentials;
  AuthCredentialsChanged({required this.credentials});
}

class AuthLogoutRequested extends AuthEvent {}