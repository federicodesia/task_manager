import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/cubits/forgot_password_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/components/forms/small_form_svg.dart';
import 'package:task_manager/theme/theme.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(
        authRepository: context.read<AuthRepository>()
      ),
      child: _ForgotPasswordScreen(),
    );
  }
}

class _ForgotPasswordScreen extends StatelessWidget{

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context){
    final customTheme = Theme.of(context).customTheme;
    
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (_, formState) {

        return SmallFormSvg(
          svgImage: "assets/svg/mention.svg",
          header: context.l10n.forgotPassword_enterEmail_title,
          description: context.l10n.forgotPassword_enterEmail_description,
          formChildren: [
            RoundedTextFormField(
              controller: emailController,
              hintText: context.l10n.textField_email,
              textInputType: TextInputType.emailAddress,
              errorText: formState.emailError,
            )
          ],
          isLoading: formState.isLoading,
          buttonText: context.l10n.continue_button,
          onButtonPressed: () async {
            try{
              context.read<ForgotPasswordCubit>().submitted(
                context: context,
                email: emailController.text.trim()
              );

              final nextState = await context.read<ForgotPasswordCubit>().stream.first;
              if(nextState.emailSent) {
                AutoRouter.of(context).navigate(
                  ForgotPasswordEmailVerificationRoute(email: emailController.text)
                );
              }
            }
            catch(_){}
          },
          bottomWidget: GestureDetector(
            child: RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                style: customTheme.smallLightTextStyle,
                children: [
                  TextSpan(text: context.l10n.forgotPassword_rememberYourPassword + " "),
                  TextSpan(
                    text: context.l10n.signIn_button + "\n",
                    style: customTheme.smallTextButtonStyle
                  ),
                ],
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            onTap: () => AutoRouter.of(context).navigate(const LoginRoute())
          ),
        );
      }
    );
  }
}