import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/components/rounded_snack_bar.dart';
import 'package:task_manager/cubits/change_password_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/components/forms/small_form_svg.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(
        authRepository: context.read<AuthRepository>()
      ),
      child: _ChangePasswordScreen(),
    );
  }
}

class _ChangePasswordScreen extends StatelessWidget{

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  get cPrimaryColor => null;

  @override
  Widget build(BuildContext context){
    
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (_, formState) {

        return SmallFormSvg(
          svgImage: "assets/svg/new_ideas.svg",
          header: context.l10n.changeMyPassword,
          description: context.l10n.changeMyPassword_description,
          formChildren: [
            RoundedTextFormField(
              controller: currentPasswordController,
              hintText: context.l10n.textField_currentPassword,
              enableObscureTextToggle: true,
              errorText: formState.currentPasswordError,
            ),

            const SizedBox(height: 16.0),

            RoundedTextFormField(
              controller: newPasswordController,
              hintText: context.l10n.textField_newPassword,
              enableObscureTextToggle: true,
              errorText: formState.newPasswordError,
            )
          ],
          isLoading: formState.isLoading,
          buttonText: context.l10n.confirm,
          onButtonPressed: () async {
            try{
              context.read<ChangePasswordCubit>().submitted(
                context: context,
                currentPassword: currentPasswordController.text,
                newPassword: newPasswordController.text
              );

              final nextState = await context.read<ChangePasswordCubit>().stream.first;
              if(nextState.changed){
                AutoRouter.of(context).pop();

                final currentContext = AutoRouter.of(context).navigatorKey.currentContext; 
                if(currentContext != null) {
                  RoundedSnackBar(
                    context: currentContext,
                    text: context.l10n.snackBar_passwordUpdated,
                    action: SnackBarAction(
                      label: "OK",
                      onPressed: () {},
                    )
                  ).show();
                }
              }
            }
            catch(_){}
          },
        );
      }
    );
  }
}