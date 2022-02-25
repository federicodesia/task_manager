import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/cubits/change_email_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/theme/theme.dart';
import '../../../constants.dart';

class ChangeEmailScreen extends StatelessWidget {
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

class _ChangeEmailScreen extends StatefulWidget{

  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<_ChangeEmailScreen>{

  final emailController = TextEditingController();
  final emailConfirmationController = TextEditingController();

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
                  child: BlocBuilder<ChangeEmailCubit, ChangeEmailState>(
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
                                      header: context.l10n.changeMyEmail,
                                      description: context.l10n.changeMyEmail_description,
                                    ),

                                    SizedBox(height: cPadding),

                                    RoundedTextFormField(
                                      controller: emailController,
                                      hintText: context.l10n.textField_newEmail,
                                      textInputType: TextInputType.emailAddress,
                                      errorText: formState.emailError,
                                    ),
                                    SizedBox(height: 16.0),

                                    RoundedTextFormField(
                                      controller: emailConfirmationController,
                                      hintText: context.l10n.textField_newEmailConfirmation,
                                      textInputType: TextInputType.emailAddress,
                                      errorText: formState.emailConfirmationError,
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
                                      context.l10n.continue_button,
                                      style: customTheme.primaryColorButtonTextStyle,
                                    ),
                                    onPressed: () async {
                                      try{
                                        context.read<ChangeEmailCubit>().submitted(
                                          context: context,
                                          email: emailController.text.trim(),
                                          emailConfirmation: emailConfirmationController.text.trim()
                                        );

                                        final nextState = await context.read<ChangeEmailCubit>().stream.first;
                                        if(nextState.emailSent) AutoRouter.of(context).replace(ChangeEmailVerificationRoute());
                                      }
                                      catch(_){}
                                    },
                                  ),
                                  SizedBox(height: 16.0),
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