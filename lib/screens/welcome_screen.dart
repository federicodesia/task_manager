import 'package:flutter/material.dart';
import 'package:task_manager/components/center_text_icon_button.dart';
import '../constants.dart';

class WelcomeScreen extends StatefulWidget{

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>{

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: cBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(cPadding),
                child: Column(
                  children: [
                    CenterTextIconButton(
                      text: "Continue with Facebook",
                      iconAsset: "assets/icons/facebook.png",
                      onPressed: () {},
                    ),
                    SizedBox(height: 12.0),

                    CenterTextIconButton(
                      text: "Continue with Google",
                      iconAsset: "assets/icons/google.png",
                      onPressed: () {},
                    ),
                    SizedBox(height: 12.0),

                    CenterTextIconButton(
                      text: "Continue with email",
                      iconAsset: "assets/icons/email.png",
                      onPressed: () {},
                    ),
                  ],
                ),
              )
            );
          }
        ),
      ),
    );
  }
}