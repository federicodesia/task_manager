import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/cubits/register_cubit.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/router/router.gr.dart';
import '../constants.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(
        authRepository: context.read<AuthRepository>(),
        authBloc: context.read<AuthBloc>()
      ),
      child: _RegisterScreen(),
    );
  }
}

class _RegisterScreen extends StatefulWidget{

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<_RegisterScreen>{

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: cBackgroundColor,
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
                  child: BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (_, formState) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [

                          Padding(
                            padding: EdgeInsets.all(cPadding),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                SizedBox(height: cPadding),
                                Text(
                                  "Create new account",
                                  style: cTitleTextStyle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8.0),

                                Text(
                                  "Please fill in the form to continue",
                                  style: cLightTextStyle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: cPadding * 2),

                                RoundedTextFormField(
                                  controller: nameController,
                                  hintText: "Name",
                                  errorText: formState.nameError
                                ),
                                SizedBox(height: 16.0),

                                RoundedTextFormField(
                                  controller: emailController,
                                  hintText: "Email",
                                  textInputType: TextInputType.emailAddress,
                                  errorText: formState.emailError
                                ),
                                SizedBox(height: 16.0),

                                RoundedTextFormField(
                                  controller: passwordController,
                                  hintText: "Password",
                                  obscureText: obscurePassword,
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
                                            obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                            key: Key("IconButtonObscurePasswordKeyValue=$obscurePassword"),
                                          ),
                                        ),
                                        splashRadius: 24.0,
                                        color: cLightGrayColor,
                                        onPressed: () {
                                          setState(() => obscurePassword = !obscurePassword);
                                        },
                                      ),
                                    ),
                                  ),
                                  errorText: formState.passwordError,
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
                                  color: cCardBackgroundColor,
                                  width: double.infinity,
                                  child: Text(
                                    "Sign Up",
                                    style: cBoldTextStyle,
                                  ),
                                  onPressed: (){

                                    context.read<RegisterCubit>().submitted(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text
                                    );
                                  },
                                ),
                                SizedBox(height: cPadding),

                                GestureDetector(
                                  child: RichText(
                                    text: TextSpan(
                                      style: cSmallLightTextStyle,
                                      children: <TextSpan>[
                                        TextSpan(text: "Already have an Account? "),
                                        TextSpan(text: "Sign In", style: cSmallLightTextStyle.copyWith(color: cTextButtonColor)),
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
                                ),
                              ],
                            ),
                          )
                        ]
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