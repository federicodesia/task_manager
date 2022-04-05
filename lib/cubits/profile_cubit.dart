import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/validators/validators.dart';

enum FieldStatus { editable, saveable, saving }

class ProfileState {
  final FieldStatus nameStatus;
  final String? nameError;
  
  const ProfileState({
    this.nameStatus = FieldStatus.editable,
    this.nameError
  });

  ProfileState copyWith({
    FieldStatus? nameStatus,
    String? nameError
  }){
    return ProfileState(
      nameStatus: nameStatus ?? this.nameStatus,
      nameError: nameError ?? this.nameError
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  
  final AuthBloc authBloc;

  ProfileCubit({
    required this.authBloc
  }) : super(const ProfileState());

  void namePressed({
    required BuildContext context,
    required String name
  }) async{

    if(state.nameStatus == FieldStatus.saveable){
      final nameError = Validators.validateName(context, name);
      if(nameError == null){
        emit(state.copyWith(
          nameStatus: FieldStatus.saving,
          nameError: null
        ));
        
        await Future.delayed(const Duration(milliseconds: 800));

        if(name != authBloc.state.user?.name){
          final updatedUser = await authBloc.userRepository.updateUser(name: name);
          if(updatedUser != null) authBloc.add(AuthUserChanged(updatedUser));
        }
        
        emit(state.copyWith(nameStatus: FieldStatus.editable));
      }
      else{
        emit(state.copyWith(
          nameStatus: FieldStatus.saveable,
          nameError: nameError
        ));
      }
    }
    else if(state.nameStatus == FieldStatus.editable){
      emit(state.copyWith(
        nameStatus: FieldStatus.saveable
      ));
    }
  }
}