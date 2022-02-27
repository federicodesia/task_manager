import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/models/active_session.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

part 'auth_bloc.g.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {

  final AuthRepository authRepository;
  final UserRepository userRepository;

  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  late StreamSubscription firebaseMessagingTokenSubscription;

  AuthBloc({
    required this.authRepository,
    required this.userRepository
  }) : super(AuthState()){

    firebaseMessagingTokenSubscription = firebaseMessaging.onTokenRefresh.listen((token) async {
      if(state.credentials.isNotEmpty){
        print("FirebaseMessagingTokenSubscription: $token");
        await authRepository.setFirebaseMessagingToken(token: token);
      }
    });

    on<AuthLoaded>((event, emit) async{

      final String? refreshToken = await secureStorage.read(key: "refreshToken");
      final String? accessToken = await secureStorage.read(key: "accessToken");

      emit(state.copyWith(
        credentials: state.credentials.copyWith(
          refreshToken: refreshToken,
          accessToken: accessToken
        )
      ));

      final credentials = state.credentials;
      if(credentials.isNotEmpty){
        
        final response = await authRepository.accessToken(
          authCredentials: credentials,
          ignoreKeys: ["Unauthorized"]
        );
        if(response != null){
          add(AuthCredentialsChanged(credentials: response));

          await firebaseMessaging.getToken().then((token) async{
            print("FirebaseMessagingToken: $token");
            if(token != null) await authRepository.setFirebaseMessagingToken(token: token);
          });
        }
        else add(AuthCredentialsChanged(credentials: AuthCredentials.empty));
      }
      else Future.delayed(Duration(seconds: 1), () {
        add(AuthCredentialsChanged(credentials: AuthCredentials.empty));
      });
    });
    
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
        final response = await userRepository.getUser();
        if(response != null) response.when(
          left: (error) {},
          right: (user) => emit(state.copyWith(user: user))
        );
      }
    });

    on<AuthUserChanged>((event, emit) async{
      emit(state.copyWith(user: event.user));
    });

    on<AuthLogoutRequested>((event, emit){
      authRepository.logout();
      add(AuthCredentialsChanged(credentials: AuthCredentials.empty));
    });

    on<AuthLogoutAllRequested>((event, emit) async{
      final response = await authRepository.logoutAll();
      if(response) add(AuthCredentialsChanged(credentials: AuthCredentials.empty));
    });

    on<UpdateActiveSessionsRequested>((event, emit) async{
      final currentToken = state.credentials.refreshToken;
      final response = await authRepository.getActiveSessions();
      
      if(response != null) emit(state.copyWith(
        activeSessions: response.map((activeSession) => activeSession.token == currentToken
          ? activeSession.copyWith(isThisDevice: true) : activeSession
        ).toList()..sort((a, b) => b.isThisDevice ? 1 : -1))
      );
    });
  }

  @override
  Future<void> close() {
    firebaseMessagingTokenSubscription.cancel();
    return super.close();
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try{
      return AuthState.fromJson(json);
    }
    catch(error) {}
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    try{
      return state.toJson();
    }
    catch(error) {}
  }
}