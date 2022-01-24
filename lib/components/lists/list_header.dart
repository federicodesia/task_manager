import 'package:flutter/material.dart';
import 'package:task_manager/theme/theme.dart';

class ListHeader extends StatelessWidget{

  final String text;
  ListHeader(this.text);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        text,
        style: customTheme.boldTextStyle
      ),
    );
  }
}