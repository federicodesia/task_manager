import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/cubits/login_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/theme/theme.dart';
import '../constants.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        authRepository: context.read<AuthRepository>(),
        authBloc: context.read<AuthBloc>()
      ),
      child: _LoginScreen(),
    );
  }
}

class _LoginScreen extends StatefulWidget{

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen>{

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  bool obscurePassword = true;

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
                  child: BlocBuilder<LoginCubit, LoginState>(
                    builder: (_, formState) {
                      return IgnorePointer(
                        ignoring: formState.isLoading,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            Padding(
                              padding: EdgeInsets.all(cPadding),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  SizedBox(height: cPadding),
                                  Text(
                                    context.l10n.loginScreen_title,
                                    style: customTheme.titleTextStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8.0),

                                  Text(
                                    context.l10n.loginScreen_description,
                                    style: customTheme.lightTextStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: cPadding * 2),

                                  RoundedTextFormField(
                                    controller: emailController,
                                    hintText: context.l10n.textField_email,
                                    textInputType: TextInputType.emailAddress,
                                    errorText: formState.emailError
                                  ),
                                  SizedBox(height: 16.0),

                                  RoundedTextFormField(
                                    controller: passwordController,
                                    hintText: context.l10n.textField_password,
                                    errorText: formState.passwordError,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    obscureText: obscurePassword,
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: IconButton(
                                          icon: AnimatedSwitcher(
                                            duration: cFastAnimationDuration,
                                            child: Icon(
                                              obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                              key: Key("IconButtonObscurePasswordKeyValue=$obscurePassword"),
                                            ),
                                          ),
                                          splashRadius: 24.0,
                                          color: customTheme.lightColor,
                                          onPressed: () {
                                            setState(() => obscurePassword = !obscurePassword);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.0),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        child: Text(
                                          context.l10n.loginScreen_forgotPassword,
                                          style: customTheme.smallLightTextStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        onTap: () {
                                          AutoRouter.of(context).navigate(ForgotPasswordRoute());
                                        },
                                      ),
                                    ],
                                  ),                          
                                ],
                              ),
                            ),
                            
                            Spacer(),

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
                                      context.l10n.signIn_button,
                                      style: customTheme.primaryColorButtonTextStyle,
                                    ),
                                    onPressed: () {
                                      context.read<LoginCubit>().submitted(
                                        context: context,
                                        email: emailController.text.trim(),
                                        password: passwordController.text
                                      );
                                    },
                                  ),
                                  SizedBox(height: cPadding),

                                  GestureDetector(
                                    child: RichText(
                                      text: TextSpan(
                                        style: customTheme.smallLightTextStyle,
                                        children: <TextSpan>[
                                          TextSpan(text: context.l10n.loginScreen_dontHaveAnAccount),
                                          TextSpan(text: " "),
                                          TextSpan(text: context.l10n.signUp_button, style: customTheme.smallTextButtonStyle),
                                          TextSpan(text: "\n")
                                        ],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      AutoRouter.of(context).navigate(RegisterRoute());
                                    },
                                  ),
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