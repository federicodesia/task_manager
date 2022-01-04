import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/register_bloc/register_bloc.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/router/router.gr.dart';
import '../constants.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(authRepository: context.read<AuthRepository>()),
      child: _RegisterScreen(),
    );
  }
}

class _RegisterScreen extends StatefulWidget{

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<_RegisterScreen>{
  
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                  child: BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (_, registerState) {
                      return Form(
                        key: formKey,
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
                                    errorText: registerState.nameError,
                                    /*validator: (value){
                                      value = value ?? "";
                                      if(value.isEmpty) return "Please enter your name";
                                      return null;
                                    }*/
                                  ),
                                  SizedBox(height: 16.0),

                                  RoundedTextFormField(
                                    controller: emailController,
                                    hintText: "Email",
                                    errorText: registerState.emailError,
                                    /*validator: (value){
                                      value = value ?? "";
                                      if(value.isEmpty) return "Please enter your email";
                                      return null;
                                    }*/
                                  ),
                                  SizedBox(height: 16.0),

                                  RoundedTextFormField(
                                    controller: passwordController,
                                    hintText: "Password",
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
                                          color: cLightGrayColor,
                                          onPressed: () {
                                            setState(() => obscurePassword = !obscurePassword);
                                          },
                                        ),
                                      ),
                                    ),
                                    /*validator: (value){
                                      value = value ?? "";
                                      if(value.isEmpty) return "Please enter your password";
                                      return null;
                                    }*/
                                    errorText: registerState.passwordError,
                                  ),                   
                                ],
                              ),
                            ),
                            
                            Spacer(),

                            Padding(
                              padding: EdgeInsets.all(cPadding),
                              child: Column(
                                children: [
                                  RoundedButton(
                                    color: cCardBackgroundColor,
                                    width: double.infinity,
                                    child: Text(
                                      "Sign Up",
                                      style: cBoldTextStyle,
                                    ),
                                    onPressed: () async {

                                      if(formKey.currentState!.validate()){
                                        formKey.currentState!.save();

                                        context.read<RegisterBloc>().add(RegisterSubmitted(
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text
                                        ));
                                      }
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