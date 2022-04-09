import 'package:flutter/material.dart';
import 'package:task_manager/theme/theme.dart';

class FormInputHeader extends StatelessWidget{

  final String text;
  const FormInputHeader(
    this.text,
    {Key? key}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
        bottom: 8.0
      ),
      child: Text(
        text,
        style: customTheme.boldTextStyle,
        maxLines: 1,
      ),
    );
  }
}