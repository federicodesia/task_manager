import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class CalendarGroupHour extends StatelessWidget{

  final DateTime dateTime;
  CalendarGroupHour({
    required this.dateTime,
  });

  @override
  Widget build(BuildContext _) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: cListItemSpace),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CalendarGroupHourText(text: DateFormat("HH:mm").format(dateTime).toLowerCase()),
                CalendarGroupHourText(text: "12:00 ", visible: false)
              ],
            ),

            Expanded(
              child: Divider()
            )
          ],
        ),
      ),
    );
  }
}

class CalendarGroupHourText extends StatelessWidget{
  final String text;
  final bool visible;

  CalendarGroupHourText({
    required this.text,
    this.visible = true
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Opacity(
      opacity: visible ? 1 : 0,
      child: Padding(
        padding: EdgeInsets.only(right: 12.0),
        child: Text(
          text,
          style: customTheme.lightTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}