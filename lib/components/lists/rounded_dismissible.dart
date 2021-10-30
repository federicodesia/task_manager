import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class RoundedDismissible extends StatelessWidget{

  final Key key;
  final String text;
  final IconData icon;
  final Color color;
  final Widget child;
  final DismissDirectionCallback onDismissed;

  RoundedDismissible({
    required this.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.child,
    required this.onDismissed
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(cBorderRadius)),
      child: Dismissible(
        key: key,
        direction: DismissDirection.endToStart,
        background: Container(
          padding: EdgeInsets.symmetric(horizontal: cPadding),
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                text,
                style: cTextStyle,
              ),
              SizedBox(width: 12.0),
              Icon(
                icon,
                color: Colors.white,
              )
            ],
          )
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.centerRight,
              colors: [
                cBackgroundColor,
                color
              ]
            )
          ),
          child: child,
        ),
        onDismissed: onDismissed,
      ),
    );
  }
}