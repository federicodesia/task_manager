import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/router/router.gr.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget{

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
                  child: Form(
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
                                "Welcome back!",
                                style: cTitleTextStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8.0),

                              Text(
                                "Please sign in to your account",
                                style: cLightTextStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: cPadding * 2),

                              RoundedTextFormField(
                                hintText: "Email",
                                validator: (value){
                                  value = value ?? "";
                                  if(value.isEmpty) return "Please enter your email";
                                  return null;
                                }
                              ),
                              SizedBox(height: 16.0),

                              RoundedTextFormField(
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
                                validator: (value){
                                  value = value ?? "";
                                  if(value.isEmpty) return "Please enter your password";
                                  return null;
                                }
                              ),
                              SizedBox(height: 16.0),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Forgot Password?",
                                    style: cSmallLightTextStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                              RoundedButton(
                                color: cCardBackgroundColor,
                                width: double.infinity,
                                child: Text(
                                  "Sign In",
                                  style: cBoldTextStyle,
                                ),
                                onPressed: () {
                                  if(formKey.currentState!.validate()){
                                    formKey.currentState!.save();
                                  }
                                },
                              ),
                              SizedBox(height: cPadding),

                              GestureDetector(
                                child: RichText(
                                  text: TextSpan(
                                    style: cSmallLightTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(text: "Don't have an Account? "),
                                      TextSpan(text: "Sign Up", style: cSmallLightTextStyle.copyWith(color: cTextButtonColor)),
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