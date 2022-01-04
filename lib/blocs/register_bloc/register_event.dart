part of 'register_bloc.dart';

abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String name;
  final String email;
  final String password;

  RegisterSubmitted({
    required this.name,
    required this.email,
    required this.password
  });
}