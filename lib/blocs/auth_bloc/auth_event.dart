part of 'auth_bloc.dart';

abstract class AuthEvent {}

class DataNotificationReceived extends AuthEvent {
  final DataNotificationType? type;
  DataNotificationReceived(this.type);
}

class AuthLoaded extends AuthEvent {}

class AuthCredentialsChanged extends AuthEvent {
  final AuthCredentials credentials;
  AuthCredentialsChanged({required this.credentials});
}

class AuthUserChanged extends AuthEvent {
  final User user;
  AuthUserChanged(this.user);
}
class UpdateUserRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}
class AuthLogoutAllRequested extends AuthEvent {}
class AuthLogoutSessionRequested extends AuthEvent {
  final int sessionId;
  AuthLogoutSessionRequested({required this.sessionId});
}

class NotifyNewSessionRequested extends AuthEvent {}
class UpdateActiveSessionsRequested extends AuthEvent {}