import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class RoundedAlertDialog{

  final BuildContext buildContext;
  final String? title;
  final String? description;
  final List<Widget>? actions;

  RoundedAlertDialog({
    required this.buildContext,
    this.title,
    this.description,
    this.actions
  });

  void show(){
    showDialog(
      context: buildContext,
      barrierColor: cModalBottomSheetBarrierColor,
      builder: (_) => AlertDialog(
        backgroundColor: cBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cBorderRadius)),
        ),
        contentPadding: EdgeInsets.all(cPadding),
        actionsPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
        title: title != null ? Text(
          title!,
          style: cSubtitleTextStyle,
          textAlign: TextAlign.center
        ) : null,
        content: description != null ? Text(
          description!,
          style: cLightTextStyle,
          textAlign: TextAlign.center,
        ) : null,
        actions: actions
      )
    );
  }
}

class RoundedAlertDialogButton extends StatelessWidget{
  final String text;
  final Color? backgroundColor;
  final void Function()? onPressed;

  RoundedAlertDialogButton({
    required this.text,
    this.backgroundColor,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: cLightTextStyle,
      ),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0
        )
      ),
    );
  }
}