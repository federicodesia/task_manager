import 'package:flutter/material.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/auth_credentials.dart';
import 'package:task_manager/models/response_message.dart';
import 'package:task_manager/repositories/auth_repository.dart';

class TempHomeScreen extends StatefulWidget{

  @override
  _TempHomeScreenState createState() => _TempHomeScreenState();
}

class _TempHomeScreenState extends State<TempHomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(cPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Username",
                style: cTitleTextStyle,
              ),
              SizedBox(height: 4.0),

              Text(
                "youremail@example.com",
                style: cTextStyle,
              ),

              SizedBox(height: 64.0),

              RoundedButton(
                width: double.infinity,
                child: Text(
                  "Logout",
                  style: cBoldTextStyle,
                ),
                onPressed: () {}
              )
            ],
          ),
        ),
      ),
    );
  }
}