import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/cubits/forgot_password_new_password_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/components/forms/small_form_svg.dart';
import 'package:task_manager/theme/theme.dart';

class ForgotPasswordNewPasswordScreen extends StatelessWidget {
  const ForgotPasswordNewPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordNewPasswordCubit(
        authRepository: context.read<AuthRepository>(),
        authBloc: context.read<AuthBloc>()
      ),
      child: _ForgotPasswordNewPasswordScreen(),
    );
  }
}

class _ForgotPasswordNewPasswordScreen extends StatelessWidget{

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    final customTheme = Theme.of(context).customTheme;
    
    return BlocBuilder<ForgotPasswordNewPasswordCubit, ForgotPasswordNewPasswordState>(
      builder: (_, formState) {

        return SmallFormSvg(
          svgImage: "assets/svg/confirmed.svg",
          header: context.l10n.forgotPassword_createNewPassword,
          description: context.l10n.forgotPassword_createNewPassword_description,
          formChildren: [
            RoundedTextFormField(
              controller: passwordController,
              hintText: context.l10n.textField_newPassword,
              enableObscureTextToggle: true,
              errorText: formState.passwordError,
            )
          ],
          isLoading: formState.isLoading,
          buttonText: context.l10n.confirm,
          onButtonPressed: () async {
            try{
              context.read<ForgotPasswordNewPasswordCubit>().submitted(
                context: context,
                password: passwordController.text
              );

              final nextState = await context.read<ForgotPasswordNewPasswordCubit>().stream.first;
              if(nextState.changed) AutoRouter.of(context).navigate(const WelcomeRoute());
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