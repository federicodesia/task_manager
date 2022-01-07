import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/constants.dart';

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
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (_, authState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    authState.user.firstName,
                    style: cTitleTextStyle,
                  ),
                  SizedBox(height: 4.0),

                  Text(
                    authState.user.email,
                    style: cTextStyle,
                  ),

                  SizedBox(height: 64.0),

                  RoundedButton(
                    width: double.infinity,
                    child: Text(
                      "Logout",
                      style: cBoldTextStyle,
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                    }
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}