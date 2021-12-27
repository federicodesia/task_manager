import 'package:flutter/material.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/screens/welcome_screen.dart';
import '../constants.dart';

class RegisterScreen extends StatefulWidget{

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>{
  
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
                                hintText: "Name",
                                validator: (value){
                                  value = value ?? "";
                                  if(value.isEmpty) return "Please enter your name";
                                  return null;
                                }
                              ),
                              SizedBox(height: 16.0),

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
                                  Navigator.of(context).pop();
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