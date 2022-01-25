import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/cubits/forgot_password_cubit.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/theme/theme.dart';
import '../constants.dart';

class ForgotPasswordScreen extends StatelessWidget {
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

class _ForgotPasswordScreen extends StatefulWidget{

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<_ForgotPasswordScreen>{

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context){
    final customTheme = Theme.of(context).customTheme;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                    builder: (_, formState) {
                      return IgnorePointer(
                        ignoring: formState.isLoading,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(cPadding),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    EmptySpace(
                                      svgImage: "assets/svg/mention.svg",
                                      svgHeight: MediaQuery.of(context).orientation == Orientation.portrait
                                        ? MediaQuery.of(context).size.width * 0.35
                                        : MediaQuery.of(context).size.height * 0.35,
                                      svgBottomMargin: 64.0,
                                      header: "Forgot your password?",
                                      description: "Please enter your registered email to request a password reset.",
                                    ),

                                    SizedBox(height: cPadding),

                                    RoundedTextFormField(
                                      controller: emailController,
                                      hintText: "Email address",
                                      textInputType: TextInputType.emailAddress,
                                      errorText: formState.emailError,
                                    )
                                  ],
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(cPadding),
                              child: Column(
                                children: [
                                  if(formState.isLoading) Padding(
                                    padding: EdgeInsets.only(bottom: 32.0),
                                    child: CircularProgressIndicator(),
                                  ),

                                  RoundedButton(
                                    width: double.infinity,
                                    child: Text(
                                      "Continue",
                                      style: customTheme.primaryColorButtonTextStyle,
                                    ),
                                    onPressed: () async {
                                      context.read<ForgotPasswordCubit>().submitted(
                                        email: emailController.text.trim()
                                      );

                                      final nextState = await context.read<ForgotPasswordCubit>().stream.first;
                                      if(nextState.emailSent) AutoRouter.of(context).navigate(
                                        ForgotPasswordEmailVerificationRoute(email: emailController.text)
                                      );
                                    },
                                  ),
                                  SizedBox(height: cPadding),

                                  GestureDetector(
                                    child: RichText(
                                      text: TextSpan(
                                        style: customTheme.smallLightTextStyle,
                                        children: <TextSpan>[
                                          TextSpan(text: "Remember your password? "),
                                          TextSpan(text: "Sign In", style: customTheme.smallTextButtonStyle),
                                          TextSpan(text: "\n")
                                        ],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      AutoRouter.of(context).navigate(LoginRoute());
                                    },
                                  )
                                ],
                              ),
                            )
                          ]
                        ),
                      );
                    }
                  ),
                )
              )
            );
          }
        ),
      )
    );
  }
}