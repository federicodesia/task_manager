import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/blocs/notifications_cubit/notifications_cubit.dart';
import 'package:task_manager/blocs/transformers.dart';
import 'package:task_manager/messaging/data_notifications.dart';
import 'package:task_manager/models/active_session.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/repositories/base_repository.dart';
import 'package:task_manager/repositories/secure_storage_repository.dart';
import 'package:task_manager/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

part 'auth_bloc.g.dart';

class AuthBloc extends DriftedBloc<AuthEvent, AuthState> {

  final NotificationsCubit notificationsCubit;

  late BaseRepository baseRepository = BaseRepository(authBloc: this);
  late AuthRepository authRepository = AuthRepository(base: baseRepository);
  late UserRepository userRepository = UserRepository(base: baseRepository);
  late SecureStorageRepository secureStorageRepository = SecureStorageRepository();

  late FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  late StreamSubscription messagingTokenSubscription;
  late StreamSubscription foregroundMessagesSubscription;

  AuthBloc({
    required this.notificationsCubit,
  }) : super(AuthState.initial){
    
    messagingTokenSubscription = firebaseMessaging.onTokenRefresh.listen((token) async {
      add(UpdateFirebaseMessagingTokenRequested(token));
    });
    
    foregroundMessagesSubscription = FirebaseMessaging.onMessage.listen((message) {
      add(DataNotificationReceived(message.dataNotificationType));
    });

    on<DataNotificationReceived>((event, emit){
      final type = event.type;
      if(type == DataNotificationType.logout){
        add(AuthCredentialsChanged(AuthCredentials.empty));
      }
      else if(type == DataNotificationType.newUserData){
        add(UpdateUserRequested());
      }
      else if(type == DataNotificationType.newSession){
        add(NotifyNewSessionRequested());
      }
    });

    on<UpdateFirebaseMessagingTokenRequested>((event, emit) async {
      final token = event.token ?? await firebaseMessaging.getToken();
      if(token != null && token.isNotEmpty){

        debugPrint("UpdateFirebaseMessagingTokenRequested");
        debugPrint(token);

        final currentToken = await secureStorageRepository.read.firebaseMessagingToken;
        if(currentToken != token){
          final updated = await authRepository.setFirebaseMessagingToken(token);
          if(updated) await secureStorageRepository.write.firebaseMessagingToken(token);
        }
      }
    },
    transformer: debounceTransformer(const Duration(seconds: 1)));

    on<AuthLoaded>((event, emit) async{

      final previousStatus = state.status;
      emit(state.copyWith(
        status: AuthStatus.loading
      ));

      final credentials = await secureStorageRepository.read.authCredentials;
      if(credentials.isNotEmpty){

        final response = await authRepository.accessToken(
          authCredentials: credentials,
          ignoreStatusCodes: [ 401, 403 ]
        );

        if(response != null) {
          response.when(
            left: (responseMessage) {
              if(responseMessage.containsAnyStatusCodes([ 401, 403 ])){
                add(AuthCredentialsChanged(AuthCredentials.empty));
              }
            },
            right: (credentials) {
              add(AuthCredentialsChanged(credentials));
            }
          );
        }
        else{
          emit(state.copyWith(
            status: previousStatus != AuthStatus.loading
              ? previousStatus : AuthStatus.unauthenticated
          ));
        }
      }
      else {
        add(AuthCredentialsChanged(AuthCredentials.empty));
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
          status: credentials.isVerified
            ? AuthStatus.authenticated
            : AuthStatus.waitingVerification
        ));

        if(previousStatus != AuthStatus.authenticated
          && state.status == AuthStatus.authenticated){
          // Authenticated
          add(UpdateFirebaseMessagingTokenRequested(null));
          add(UpdateUserRequested());
        }
      }
    });

    on<AuthUserChanged>((event, emit) async{
      emit(state.copyWith(user: event.user));
    });

    on<UpdateUserRequested>((event, emit) async{
      final user = await userRepository.getUser();
      if(user != null) emit(state.copyWith(user: user));
    });

    on<AuthLogoutRequested>((event, emit){
      authRepository.logout();
      add(AuthCredentialsChanged(AuthCredentials.empty));
    });

    on<AuthLogoutAllRequested>((event, emit) async{
      final response = await authRepository.logoutAll();
      if(response) add(AuthCredentialsChanged(AuthCredentials.empty));
    });

    on<NotifyNewSessionRequested>((event, emit) async{
      notificationsCubit.showLoginOnNewDeviceNotification();
      add(UpdateActiveSessionsRequested());
    });

    on<UpdateActiveSessionsRequested>((event, emit) async{
      final currentToken = await secureStorageRepository.read.refreshToken;
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
  Future<void> close() async {
    await messagingTokenSubscription.cancel();
    await foregroundMessagesSubscription.cancel();
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