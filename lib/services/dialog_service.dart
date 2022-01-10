import 'package:flutter/material.dart';
import 'package:task_manager/components/rounded_alert_dialog.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/constants.dart';

class DialogService {
  final GlobalKey<NavigatorState> navigatoryKey = new GlobalKey<NavigatorState>();

  void showNoInternetConnectionDialog() {
    final context = navigatoryKey.currentContext;

    if(context != null) RoundedAlertDialog(
      buildContext: context,
      svgImage: "assets/svg/stars.svg",
      title: "Oops! No internet connection",
      description: "You are not connected to the Internet. Please check your connection.",
      actions: [
        RoundedButton(
          autoWidth: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text("Got it", style: cBoldTextStyle),
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop()
        ),
      ],
    ).show();
  }

  void showSomethingWentWrongDialog(){
    final context = navigatoryKey.currentContext;

    if(context != null) RoundedAlertDialog(
      buildContext: context,
      svgImage: "assets/svg/stars.svg",
      title: "Oops! Something went wrong",
      description: "Sorry, we can't process your request at the moment. Please try again later.",
      actions: [
        RoundedButton(
          autoWidth: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text("Got it", style: cBoldTextStyle),
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop()
        ),
      ],
    ).show();
  }
}