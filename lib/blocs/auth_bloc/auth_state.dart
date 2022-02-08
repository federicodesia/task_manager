part of 'auth_bloc.dart';

enum AuthStatus { loading, unauthenticated, waitingVerification, authenticated }

@JsonSerializable()
class AuthState {

  @JsonKey(ignore: true)
  final AuthStatus status;
  @JsonKey(ignore: true)
  final AuthCredentials credentials;
  final User user;

  AuthState({
    this.status = AuthStatus.loading,
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

  factory AuthState.fromJson(Map<String, dynamic> json) => _$AuthStateFromJson(json);
  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
}