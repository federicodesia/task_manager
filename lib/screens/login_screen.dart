import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import '../constants.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvailableSpaceCubit(),
      child: _LoginScreen(),
    );
  }
}

class _LoginScreen extends StatefulWidget{

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen>{

  late AvailableSpaceCubit availableSpaceCubit = BlocProvider.of<AvailableSpaceCubit>(context);
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: cBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              child: Column(
                children: [


                  WidgetSize(
                    onChange: (Size size){
                      context.read<AvailableSpaceCubit>().setHeight(constraints.maxHeight - size.height);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(cPadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          SizedBox(height: cPadding),
                          Text(
                            "Welcome back!",
                            style: cTitleTextStyle,
                          ),
                          SizedBox(height: 8.0),

                          Text(
                            "Please sign in to your account",
                            style: cSmallLightTextStyle,
                          ),
                          SizedBox(height: cPadding * 2),

                          RoundedTextFormField(
                            hintText: "Email",
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
                          ),
                          SizedBox(height: 16.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot Password?",
                                style: cSmallLightTextStyle
                              ),
                            ],
                          ),


                          SizedBox(height: 150),

                          RoundedButton(
                            color: cCardBackgroundColor,
                            width: double.infinity,
                            child: Text(
                              "Sign In",
                              style: cBoldTextStyle,
                            ),
                            onPressed: () {},
                          ),
                          SizedBox(height: cPadding),

                          FractionallySizedBox(
                            widthFactor: 0.75,
                            child: RichText(
                              text: TextSpan(
                                style: cSmallLightTextStyle,
                                children: <TextSpan>[
                                  TextSpan(text: "Don't have an Account? "),
                                  TextSpan(text: "Sign Up", style: cSmallLightTextStyle.copyWith(color: cTextButtonColor)),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            )
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            );
          }
        ),
      ),
    );
  }
}