part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  final AuthStatus status;
  AuthStatusChanged(this.status);
}

class AuthLogoutRequested extends AuthEvent {}