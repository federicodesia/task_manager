import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/cubits/change_email_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/components/forms/small_form_svg.dart';

class ChangeEmailScreen extends StatelessWidget {
  const ChangeEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangeEmailCubit(
        authRepository: context.read<AuthRepository>(),
        authBloc: context.read<AuthBloc>()
      ),
      child: _ChangeEmailScreen(),
    );
  }
}

class _ChangeEmailScreen extends StatelessWidget{

  final emailController = TextEditingController();
  final emailConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context){
    
    return BlocBuilder<ChangeEmailCubit, ChangeEmailState>(
      builder: (_, formState) {

        return SmallFormSvg(
          svgImage: "assets/svg/mention.svg",
          header: context.l10n.changeMyEmail,
          description: context.l10n.changeMyEmail_description,
          formChildren: [

            RoundedTextFormField(
              controller: emailController,
              hintText: context.l10n.textField_newEmail,
              textInputType: TextInputType.emailAddress,
              errorText: formState.emailError,
            ),
            const SizedBox(height: 16.0),

            RoundedTextFormField(
              controller: emailConfirmationController,
              hintText: context.l10n.textField_newEmailConfirmation,
              textInputType: TextInputType.emailAddress,
              errorText: formState.emailConfirmationError,
            )
          ],
          isLoading: formState.isLoading,
          buttonText: context.l10n.continue_button,
          onButtonPressed: () async {
            try{
              context.read<ChangeEmailCubit>().submitted(
                context: context,
                email: emailController.text.trim(),
                emailConfirmation: emailConfirmationController.text.trim()
              );

              final nextState = await context.read<ChangeEmailCubit>().stream.first;
              if(nextState.emailSent) AutoRouter.of(context).replace(const ChangeEmailVerificationRoute());
            }
            catch(_){}
          },
        );
      }
    );
  }
}