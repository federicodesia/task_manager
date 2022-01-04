import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/helpers/response_messages.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/response_message.dart';
import 'package:task_manager/repositories/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  final AuthRepository authRepository;
  RegisterBloc({required this.authRepository}) : super(const RegisterState()){
    
    on<RegisterSubmitted>((event, emit) async{
      final response = await authRepository.register(
        name: event.name,
        email: event.email,
        password: event.password
      );

      if(response is AuthCredentials) emit(const RegisterState());
      else if(response is List<ResponseMessage>){
        emit(RegisterState(
          nameError: ResponseMessages().getMessage(response, key: "name"),
          emailError: ResponseMessages().getMessage(response, key: "email"),
          passwordError: ResponseMessages().getMessage(response, key: "password"),
        ));
      }
    });
  }
}