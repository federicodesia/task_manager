import 'package:flutter/material.dart';
import 'package:task_manager/components/rounded_alert_dialog.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/l10n/l10n.dart';

class DialogService {

  GlobalKey<NavigatorState>? _navigatorKey;
  void init(GlobalKey<NavigatorState> key) => _navigatorKey = key;

  BuildContext? get _getCurrentContext => _navigatorKey?.currentContext;

  void showNoInternetConnectionDialog() {
    final context = _getCurrentContext;

    if(context != null){
      RoundedAlertDialog(
        buildContext: context,
        svgImage: "assets/svg/stars.svg",
        title: context.l10n.alertDialog_noInternetConnection,
        description: context.l10n.alertDialog_noInternetConnection_description,
        actions: [
          RoundedTextButton(
            expandWidth: false,
            textPadding: const EdgeInsets.symmetric(horizontal: 32.0),
            text: context.l10n.gotIt_button,
            onPressed: () => Navigator.of(context, rootNavigator: true).pop()
          ),
        ],
      ).show();
    } 
  }

  void showSomethingWentWrongDialog(){
    final context = _getCurrentContext;

    if(context != null){
      RoundedAlertDialog(
        buildContext: context,
        svgImage: "assets/svg/stars.svg",
        title: context.l10n.alertDialog_somethingWentWrong,
        description: context.l10n.alertDialog_somethingWentWrong_description,
        actions: [
          RoundedTextButton(
            expandWidth: false,
            textPadding: const EdgeInsets.symmetric(horizontal: 32.0),
            text: context.l10n.gotIt_button,
            onPressed: () => Navigator.of(context, rootNavigator: true).pop()
          ),
        ],
      ).show();
    }
  }
}