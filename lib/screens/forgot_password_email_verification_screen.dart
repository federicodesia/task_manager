import 'package:auto_route/auto_route.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/forms/verification_code.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/cubits/forgot_password_email_verification_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/theme/theme.dart';
import '../constants.dart';

class ForgotPasswordEmailVerificationScreen extends StatelessWidget {

  final String email;
  ForgotPasswordEmailVerificationScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordEmailVerificationCubit(
        authRepository: context.read<AuthRepository>(),
        authBloc: context.read<AuthBloc>(),
        email: email
      ),
      child: _ForgotPasswordEmailVerificationScreen(),
    );
  }
}

class _ForgotPasswordEmailVerificationScreen extends StatefulWidget{

  @override
  _ForgotPasswordEmailVerificationScreenState createState() => _ForgotPasswordEmailVerificationScreenState();
}

class _ForgotPasswordEmailVerificationScreenState extends State<_ForgotPasswordEmailVerificationScreen>{
  
  final codeController = TextEditingController();
  final customTimerController = CustomTimerController(
    initialState: CustomTimerState.counting
  );

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
                  child: BlocBuilder<ForgotPasswordEmailVerificationCubit, ForgotPasswordEmailVerificationState>(
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
                                      svgImage: "assets/svg/newsletter.svg",
                                      svgHeight: MediaQuery.of(context).orientation == Orientation.portrait
                                        ? MediaQuery.of(context).size.width * 0.35
                                        : MediaQuery.of(context).size.height * 0.35,
                                      svgBottomMargin: 64.0,
                                      header: context.l10n.emptySpace_verifyYourEmail,
                                      description: context.l10n.emptySpace_verifyYourEmail_description,
                                    ),

                                    SizedBox(height: cPadding),

                                    VerificationCode(
                                      controller: codeController,
                                      textInputType: TextInputType.text,
                                      length: 4,
                                      errorText: formState.codeError,
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
                                      "Confirm",
                                      style: customTheme.primaryColorButtonTextStyle,
                                    ),
                                    onPressed: () async {
                                      context.read<ForgotPasswordEmailVerificationCubit>().submitted(
                                        code: codeController.text
                                      );

                                      final nextState = await context.read<ForgotPasswordEmailVerificationCubit>().stream.first;
                                      if(nextState.verified) AutoRouter.of(context).navigate(ForgotPasswordNewPasswordRoute());
                                    },
                                  ),
                                  SizedBox(height: cPadding),

                                  CustomTimer(
                                    controller: customTimerController,
                                    begin: Duration(minutes: 2),
                                    end: Duration(),
                                    builder: (time) {
                                      return Text(
                                        context.l10n.emailVerification_resendCodeIn("${time.minutes}:${time.seconds}\n"),
                                        style: customTheme.smallLightTextStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      );
                                    },
                                    stateBuilder: (time, state) {
                                      return GestureDetector(
                                        child: RichText(
                                          text: TextSpan(
                                            style: customTheme.smallLightTextStyle,
                                            children: <TextSpan>[
                                              TextSpan(text: context.l10n.emailVerification_didntReceiveCode),
                                              TextSpan(text: " "),
                                              TextSpan(text: context.l10n.emailVerification_resend, style: customTheme.smallTextButtonStyle),
                                              TextSpan(text: "\n")
                                            ],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                        onTap: (){
                                          customTimerController.reset();
                                          customTimerController.start();

                                          context.read<ForgotPasswordEmailVerificationCubit>().sendPasswordResetCode();
                                        },
                                      );
                                    },
                                    animationBuilder: (child) {
                                      return AnimatedSwitcher(
                                        duration: cTransitionDuration,
                                        child: child,
                                      );
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