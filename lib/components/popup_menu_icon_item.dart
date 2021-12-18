import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class PopupMenuIconItem extends StatelessWidget{

  final IconData icon;
  final String text;

  PopupMenuIconItem({
    required this.icon,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: cIconColor,
        ),
        SizedBox(width: 12.0),
        Text(
          text,
          style: cLightTextStyle,
        )
      ],
    );
  }
}