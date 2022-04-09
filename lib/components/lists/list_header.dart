import 'package:flutter/material.dart';
import 'package:task_manager/theme/theme.dart';

class ListHeader extends StatelessWidget{

  final String text;

  const ListHeader(
    this.text,
    {Key? key}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        text,
        style: customTheme.boldTextStyle,
        maxLines: 1,
      ),
    );
  }
}