import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/theme/theme.dart';

class CalendarCard extends StatelessWidget{

  final DateTime dateTime;
  final bool isSelected;
  final Function()? onTap;
  
  CalendarCard({
    required this.dateTime,
    required this.isSelected,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return GestureDetector(
      child: AnimatedContainer(
        duration: cFastAnimationDuration,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(cBorderRadius)),
          color: isSelected ? cPrimaryColor : Colors.transparent
        ),
        padding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 12.0
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat("d").format(dateTime),
              style: customTheme.subtitleTextStyle.copyWith(
                color: isSelected ? Colors.white : customTheme.lightTextColor
              ),
            ),
            SizedBox(height: 4.0),

            Stack(
              alignment: Alignment.center,
              children: [
                // Text to avoid the width change generated by the names of the days.
                Opacity(
                  opacity: 0.0,
                  child: Text(
                    "aaaa",
                    style: customTheme.smallLightTextStyle,
                  ),
                ),

                Text(
                  dateTime.formatLocalization(context, format: "E"),
                  style: customTheme.smallLightTextStyle.copyWith(
                    color: isSelected ? Colors.white : customTheme.lightTextColor
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}