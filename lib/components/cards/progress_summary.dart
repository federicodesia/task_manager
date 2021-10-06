import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_manager/constants.dart';

class ProgressSummary extends StatelessWidget{

  final String header;
  final int completed;
  final int total;
  final String initialDescription;
  final String finishedDescription;

  ProgressSummary({
    this.header,
    this.completed,
    this.total,
    this.initialDescription,
    this.finishedDescription
  });

  @override
  Widget build(BuildContext context) {

    String _description;
    if(completed == 0 && initialDescription != null) _description = initialDescription;
    else if(completed == total && finishedDescription != null) _description = finishedDescription;
    else _description = "$completed of $total completed 🎉";

    return Container(
      decoration: BoxDecoration(
        color: cCardBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(cBorderRadius))
      ),
      padding: EdgeInsets.all(cPadding),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header,
                  style: cTitleTextStyle.copyWith(fontSize: 15.0),
                ),
                SizedBox(height: 8.0),

                AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  child: Align(
                    key: UniqueKey(),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _description,
                      style: cLightTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 16.0),

          CircularPercentIndicator(
            radius: 56.0,
            lineWidth: 6.0,
            animation: true,
            animateFromLastPercent: true,
            animationDuration: cAnimationDuration.inMilliseconds,
            percent: completed / total,
            center: Text(
              "${((completed / total) * 100).toStringAsFixed(0)}%",
              style: cSubtitleTextStyle,
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: cPrimaryColor.withOpacity(0.5),
            progressColor: cPrimaryColor,
          )
        ],
      )
    );
  }
}