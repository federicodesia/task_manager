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

  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  late StreamSubscription messagingTokenSubscription;
  late StreamSubscription foregroundMessagesSubscription;

  AuthBloc({
    required this.authRepository,
    required this.userRepository
  }) : super(AuthState()){

    messagingTokenSubscription = firebaseMessaging.onTokenRefresh.listen((token) async {
      await authRepository.setFirebaseMessagingToken(token);
    });
    
    foregroundMessagesSubscription = FirebaseMessaging.onMessage.listen((message) {
      
      final type = message.data["type"];
      if(type == "logout"){
        add(AuthCredentialsChanged(credentials: AuthCredentials.empty));
      }
      else if(type == "new-user-data"){}
      else if(type == "new-session"){}
    });

    on<AuthLoaded>((event, emit) async{
      final String? refreshToken = await secureStorage.read(key: "refreshToken");
      final String? accessToken = await secureStorage.read(key: "accessToken");
      final String? passwordToken = await secureStorage.read(key: "passwordToken");

      emit(state.copyWith(
        credentials: state.credentials.copyWith(
          refreshToken: refreshToken,
          accessToken: accessToken,
          passwordToken: passwordToken
        )
      ));

      final credentials = state.credentials;
      if(credentials.isNotEmpty){

        final response = await authRepository.accessToken(
          authCredentials: credentials,
          ignoreStatusCodes: [ 401, 403 ]
        );
        if(response != null) {
          response.when(
            left: (responseMessage) {
              if(responseMessage.containsAnyStatusCodes([ 401, 403 ])){
                add(AuthCredentialsChanged(credentials: AuthCredentials.empty));
              }
            },
            right: (credentials) {
              add(AuthCredentialsChanged(credentials: credentials));
            }
          );
        }
      }
    });
    
    on<AuthCredentialsChanged>((event, emit) async{
      final previousStatus = state.status;
      final credentials = event.credentials;

      if(credentials.isEmpty){
        // Unauthenticated
        secureStorage.deleteAll();
        emit(AuthState(status: AuthStatus.unauthenticated));
      }
      else{
        secureStorage.write(key: "refreshToken", value: credentials.refreshToken);
        secureStorage.write(key: "accessToken", value: credentials.accessToken);
        secureStorage.write(key: "passwordToken", value: credentials.passwordToken);

        emit(state.copyWith(
          credentials: credentials,
          status: credentials.isVerified
            ? AuthStatus.authenticated
            : AuthStatus.waitingVerification
        ));

        if(previousStatus != AuthStatus.authenticated
          && state.status == AuthStatus.authenticated){
          // Authenticated
          final messagingToken = await firebaseMessaging.getToken();
          if(messagingToken != null) await authRepository.setFirebaseMessagingToken(messagingToken);

          final user = await userRepository.getUser();
          if(user != null) emit(state.copyWith(user: user));
        }
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
      
      if(response != null) {
        emit(state.copyWith(
          activeSessions: response.map((activeSession) => activeSession.token == currentToken
            ? activeSession.copyWith(isThisDevice: true) : activeSession
          ).toList()..sort((a, b) => b.isThisDevice ? 1 : -1))
        );
      }
    });

    on<AuthLogoutSessionRequested>((event, emit) async{
      final response = await authRepository.logoutBySessionId(sessionId: event.sessionId);
      
      if(response) {
        emit(state.copyWith(
          activeSessions: state.activeSessions
            ..removeWhere((activeSession) => activeSession.id == event.sessionId))
        );
      }
    });
  }

  @override
  Future<void> close() {
    messagingTokenSubscription.cancel();
    foregroundMessagesSubscription.cancel();
    return super.close();
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try{
      return AuthState.fromJson(json);
    }
    catch(error) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    try{
      return state.toJson();
    }
    catch(error) {
      return null;
    }
  }
}