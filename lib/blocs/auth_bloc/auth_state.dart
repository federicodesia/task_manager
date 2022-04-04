part of 'auth_bloc.dart';

enum AuthStatus { loading, unauthenticated, waitingVerification, authenticated }

@JsonSerializable()
class AuthState {

  final AuthStatus status;
  final User? user;
  final bool shouldUpdateUser;
  final List<ActiveSession> activeSessions;

  AuthState({
    required this.status,
    required this.user,
    required this.shouldUpdateUser,
    required this.activeSessions,
  });

  static AuthState get initial => AuthState(
    status: AuthStatus.loading,
    user: null,
    shouldUpdateUser: false,
    activeSessions: []
  );

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    bool? shouldUpdateUser,
    List<ActiveSession>? activeSessions
  }){
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      shouldUpdateUser: shouldUpdateUser ?? this.shouldUpdateUser,
      activeSessions: activeSessions ?? this.activeSessions
    );
  }

  factory AuthState.fromJson(Map<String, dynamic> json) => _$AuthStateFromJson(json);
  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
}