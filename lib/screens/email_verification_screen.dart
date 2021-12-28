import 'package:flutter/material.dart';
import 'package:task_manager/components/empty_space.dart';
import 'package:task_manager/components/rounded_button.dart';
import '../constants.dart';

class EmailVerificationScreen extends StatefulWidget{

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>{
  
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                                  svgBottomMargin: 48.0,
                                  header: "Verify your email",
                                  description: "Please enter the 4 digit verification code sent to your email address.",
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
                                onPressed: () {},
                              ),
                              SizedBox(height: cPadding),

                              GestureDetector(
                                child: RichText(
                                  text: TextSpan(
                                    style: cSmallLightTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(text: "Didn't receive the code? "),
                                      TextSpan(text: "Resend", style: cSmallLightTextStyle.copyWith(color: cTextButtonColor)),
                                      TextSpan(text: "\n")
                                    ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () {},
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