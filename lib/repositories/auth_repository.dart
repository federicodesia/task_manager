import 'dart:async';

import 'package:dio/dio.dart';
import 'package:task_manager/helpers/response_messages.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/response_message.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthRepository {

  final _controller = StreamController<AuthStatus>();
  final _dio = Dio(
    BaseOptions(
      baseUrl: "https://yusuf007r.dev/task-manager/auth",
      validateStatus: (_) => true
    )
  );

  Stream<AuthStatus> get status async* {
    yield* _controller.stream;
  }

  Future<dynamic> register({
    required String name,
    required String email,
    required String password,
  }) async {

    final response = await _dio.post('/register', data: {
      "firstName": name,
      "lastName": name,
      "email": email,
      "password": password,
    });

    int? statusCode = response.statusCode;
    if(statusCode != null){
      if(statusCode == 201){
        final authCredentials = AuthCredentials.fromJson(response.data);

        if(authCredentials.isNotEmpty){
          _controller.add(AuthStatus.authenticated);
          return authCredentials;
        }
      }
      else{
        final message = response.data["message"];
        return ResponseMessages().from(message, keys: ["firstname", "lastname", "email", "password"]);
      }
    }
  }

  void logOut() {
    _controller.add(AuthStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}