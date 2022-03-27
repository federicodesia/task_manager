import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/models/active_session.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/repositories/secure_storage_repository.dart';
import 'package:task_manager/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

part 'auth_bloc.g.dart';

class AuthBloc extends DriftedBloc<AuthEvent, AuthState> {

  final AuthRepository authRepository;
  final UserRepository userRepository;

  SecureStorageRepository secureStorageRepository = SecureStorageRepository();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  late StreamSubscription messagingTokenSubscription;
  late StreamSubscription foregroundMessagesSubscription;

  AuthBloc({
    required this.authRepository,
    required this.userRepository
  }) : super(AuthState.initial){

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
      final messagingToken = await firebaseMessaging.getToken();
      print("messagingToken: $messagingToken");

      final storedCredentials = await secureStorageRepository.read.authCredentials;

      emit(state.copyWith(credentials:
        state.credentials.merge(storedCredentials)
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
      else {
        add(AuthCredentialsChanged(credentials: AuthCredentials.empty));
      }
    });
    
    on<AuthCredentialsChanged>((event, emit) async{
      final previousStatus = state.status;
      final credentials = event.credentials;

      if(credentials.isEmpty){
        // Unauthenticated
        secureStorageRepository.delete.all();
        emit(AuthState.initial.copyWith(
          status: AuthStatus.unauthenticated
        ));
      }
      else{
        await secureStorageRepository.write.authCredentials(credentials);

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