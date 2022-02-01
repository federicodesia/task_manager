import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AuthRepository authRepository;
  final UserRepository userRepository;

  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  AuthBloc({
    required this.authRepository,
    required this.userRepository
  }) : super(AuthState(status: AuthStatus.loading)){
    autoLogin();
    
    on<AuthCredentialsChanged>((event, emit) async{
      final credentials = event.credentials;

      if(credentials.isEmpty) secureStorage.deleteAll();
      else{
        secureStorage.write(key: "refreshToken", value: credentials.refreshToken);
        secureStorage.write(key: "accessToken", value: credentials.accessToken);
      }

      emit(state.copyWith(
        credentials: credentials,
        status: credentials.isNotEmpty
          ? credentials.accessTokenType == TokenType.access
            ? credentials.isVerified
              ? AuthStatus.authenticated
              : AuthStatus.waitingVerification
            : AuthStatus.unauthenticated
          : AuthStatus.unauthenticated
      ));

      if(credentials.accessTokenType == TokenType.access && credentials.isVerified){
        final response = await userRepository.getUser(authCredentials: credentials);
        if(response != null) response.when(
          left: (error) {},
          right: (user) => emit(state.copyWith(user: user))
        );
      }
    });

    on<AuthLogoutRequested>((event, emit){
      authRepository.logout(authCredentials: state.credentials);
      add(AuthCredentialsChanged(credentials: AuthCredentials.empty));
    });
  }

  void autoLogin() async{
    final String? refreshToken = await secureStorage.read(key: "refreshToken");
    final String? accessToken = await secureStorage.read(key: "accessToken");

    final credentials = AuthCredentials(
      refreshToken: refreshToken ?? "",
      accessToken: accessToken ?? ""
    );

    if(credentials.isNotEmpty){
      final response = await authRepository.accessToken(authCredentials: credentials);

      response.when(
        left: (error) => add(AuthCredentialsChanged(credentials: AuthCredentials.empty)),
        right: (authCredentials) => add(AuthCredentialsChanged(credentials: authCredentials))
      );
    }
    else Future.delayed(Duration(seconds: 1), () {
      add(AuthCredentialsChanged(credentials: AuthCredentials.empty));
    });
  }
}