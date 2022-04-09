import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class RoundedDismissible extends StatelessWidget{

  final String text;
  final IconData icon;
  final Color color;
  final Widget child;
  final DismissDirectionCallback onDismissed;

  const RoundedDismissible({
    Key? key,
    required this.text,
    required this.icon,
    required this.color,
    required this.child,
    required this.onDismissed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(cBorderRadius)),
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: cPadding),
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                text,
                style: customTheme.textStyle.copyWith(color: Colors.white),
                maxLines: 1,
              ),
              const SizedBox(width: 12.0),
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
                customTheme.backgroundColor,
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