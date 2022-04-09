import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/theme/theme.dart';

class CalendarGroupHour extends StatelessWidget{

  final DateTime dateTime;
  const CalendarGroupHour({
    Key? key, 
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: cListItemSpace),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CalendarGroupHourText(text: dateTime.format(context, "HH:mm")),
                const CalendarGroupHourText(text: "12:00 ", visible: false)
              ],
            ),

            const Expanded(
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

  const CalendarGroupHourText({
    Key? key, 
    required this.text,
    this.visible = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Opacity(
      opacity: visible ? 1 : 0,
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Text(
          text,
          style: customTheme.lightTextStyle,
          maxLines: 1
        ),
      ),
    );
  }
}