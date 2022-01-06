part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthStateChanged extends AuthEvent {
  final AuthState state;
  AuthStateChanged({required this.state});
}