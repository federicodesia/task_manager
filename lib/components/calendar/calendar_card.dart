import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/constants.dart';

class CalendarCard extends StatelessWidget{

  final DateTime dateTime;
  final bool isSelected;
  
  CalendarCard({
    required this.dateTime,
    required this.isSelected
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat('d').format(dateTime),
          style: cTextStyle.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: isSelected ? cTextColor : cLightTextColor
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
                style: cLightTextStyle.copyWith(fontSize: 13.0),
              ),
            ),

            Text(
              DateFormat('E').format(dateTime),
              style: cLightTextStyle.copyWith(
                fontSize: 13.0,
                color: isSelected ? cTextColor : cLightTextColor
              ),
            )
          ],
        ),
      ],
    );
  }
}