import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/forms/rounded_text_form_field.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/router/router.gr.dart';
import '../constants.dart';

class ChangeForgotPasswordScreen extends StatefulWidget{

  @override
  _ChangeForgotPasswordScreenState createState() => _ChangeForgotPasswordScreenState();
}

class _ChangeForgotPasswordScreenState extends State<ChangeForgotPasswordScreen>{

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
                                svgImage: "assets/svg/confirmed.svg",
                                svgHeight: MediaQuery.of(context).orientation == Orientation.portrait
                                  ? MediaQuery.of(context).size.width * 0.35
                                  : MediaQuery.of(context).size.height * 0.35,
                                svgBottomMargin: 64.0,
                                header: "Create new password",
                                description: "We are ready! Now enter your new password that you will use to log in.",
                              ),

                              SizedBox(height: cPadding),

                              RoundedTextFormField(
                                hintText: "New password",
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
                              )
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(cPadding),
                        child: Column(
                          children: [
                            RoundedButton(
                              color: cCardBackgroundColor,
                              width: double.infinity,
                              child: Text(
                                "Confirm",
                                style: cBoldTextStyle,
                              ),
                              onPressed: () {

                              },
                            ),
                            SizedBox(height: cPadding),

                            GestureDetector(
                              child: RichText(
                                text: TextSpan(
                                  style: cSmallLightTextStyle,
                                  children: <TextSpan>[
                                    TextSpan(text: "Remember your password? "),
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
                            )
                          ],
                        ),
                      )
                    ]
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