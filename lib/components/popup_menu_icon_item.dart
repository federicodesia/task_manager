import 'package:flutter/material.dart';
import 'package:task_manager/theme/theme.dart';

class PopupMenuIconItem extends StatelessWidget{

  final IconData icon;
  final String text;

  const PopupMenuIconItem({
    Key? key, 
    required this.icon,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return Row(
      children: [
        Icon(
          icon,
          color: customTheme.lightColor,
        ),
        const SizedBox(width: 12.0),
        Text(
          text,
          style: customTheme.lightTextStyle,
          maxLines: 1,
        )
      ],
    );
  }
}