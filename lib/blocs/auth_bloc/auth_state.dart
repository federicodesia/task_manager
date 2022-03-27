part of 'auth_bloc.dart';

enum AuthStatus { loading, unauthenticated, waitingVerification, authenticated }

@JsonSerializable()
class AuthState {

  final AuthStatus status;
  @JsonKey(ignore: true)
  final AuthCredentials credentials;
  final User user;
  final List<ActiveSession> activeSessions;

  AuthState({
    required this.status,
    this.credentials = AuthCredentials.empty,
    required this.user,
    required this.activeSessions,
  });

  static AuthState get initial => AuthState(
    status: AuthStatus.loading,
    credentials: AuthCredentials.empty,
    user: User.empty,
    activeSessions: []
  );

  AuthState copyWith({
    AuthStatus? status,
    AuthCredentials? credentials,
    User? user,
    List<ActiveSession>? activeSessions
  }){
    return AuthState(
      status: status ?? this.status,
      credentials: credentials ?? this.credentials,
      user: user ?? this.user,
      activeSessions: activeSessions ?? this.activeSessions
    );
  }

  factory AuthState.fromJson(Map<String, dynamic> json) => _$AuthStateFromJson(json);
  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
}