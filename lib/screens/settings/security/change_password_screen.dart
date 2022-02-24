import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/cubits/change_password_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/theme/theme.dart';
import '../../../constants.dart';

class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(
        authRepository: context.read<AuthRepository>(),
        authBloc: context.read<AuthBloc>()
      ),
      child: _ChangePasswordScreen(),
    );
  }
}

class _ChangePasswordScreen extends StatefulWidget{

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<_ChangePasswordScreen>{

  final currentPasswordController = TextEditingController();
  bool obscureCurrentPassword = true;

  final newPasswordController = TextEditingController();
  bool obscureNewPassword = true;

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
                  child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
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
                                      svgImage: "assets/svg/new_ideas.svg",
                                      svgHeight: MediaQuery.of(context).orientation == Orientation.portrait
                                        ? MediaQuery.of(context).size.width * 0.35
                                        : MediaQuery.of(context).size.height * 0.35,
                                      svgBottomMargin: 64.0,
                                      header: context.l10n.changeMyPassword,
                                      description: context.l10n.changeMyPassword_description,
                                    ),

                                    SizedBox(height: cPadding),

                                    RoundedTextFormField(
                                      controller: currentPasswordController,
                                      hintText: context.l10n.textField_currentPassword,
                                      obscureText: obscureCurrentPassword,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: IconButton(
                                            icon: AnimatedSwitcher(
                                              duration: cFastAnimationDuration,
                                              child: Icon(
                                                obscureCurrentPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                                key: Key("IconButtonObscureCurrentPasswordKeyValue=$obscureCurrentPassword"),
                                              ),
                                            ),
                                            splashRadius: 24.0,
                                            color: customTheme.lightColor,
                                            onPressed: () {
                                              setState(() => obscureCurrentPassword = !obscureCurrentPassword);
                                            },
                                          ),
                                        ),
                                      ),
                                      errorText: formState.currentPasswordError,
                                    ),

                                    SizedBox(height: 16.0),

                                    RoundedTextFormField(
                                      controller: newPasswordController,
                                      hintText: context.l10n.textField_newPassword,
                                      obscureText: obscureNewPassword,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: IconButton(
                                            icon: AnimatedSwitcher(
                                              duration: cFastAnimationDuration,
                                              child: Icon(
                                                obscureNewPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                                key: Key("IconButtonObscureNewPasswordKeyValue=$obscureNewPassword"),
                                              ),
                                            ),
                                            splashRadius: 24.0,
                                            color: customTheme.lightColor,
                                            onPressed: () {
                                              setState(() => obscureNewPassword = !obscureNewPassword);
                                            },
                                          ),
                                        ),
                                      ),
                                      errorText: formState.newPasswordError,
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
                                      context.l10n.confirm,
                                      style: customTheme.primaryColorButtonTextStyle,
                                    ),
                                    onPressed: () async {
                                      try{
                                        context.read<ChangePasswordCubit>().submitted(
                                          context: context,
                                          currentPassword: currentPasswordController.text,
                                          newPassword: newPasswordController.text
                                        );

                                        final nextState = await context.read<ChangePasswordCubit>().stream.first;
                                        if(nextState.changed) AutoRouter.of(context).pop();
                                      }
                                      catch(_){}
                                    },
                                  ),
                                  SizedBox(height: 16.0)
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