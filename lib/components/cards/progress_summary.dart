import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/components/responsive/animated_widget_size.dart';
import 'package:task_manager/constants.dart';

class ProgressSummary extends StatelessWidget{

  final String header;
  final int completed;
  final int total;
  final String? initialDescription;
  final String? finishedDescription;

  ProgressSummary({
    required this.header,
    required this.completed,
    required this.total,
    this.initialDescription,
    this.finishedDescription
  });

  @override
  Widget build(BuildContext context) {

    String _description;
    if(completed == 0 && initialDescription != null) _description = initialDescription!;
    else if(completed == total && finishedDescription != null) _description = finishedDescription!;
    else _description = "$completed of $total completed 🎉";

    double _percent = total > 0 ? completed / total : 0.0;

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
                  style: cBoldTextStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.0),

                AnimatedWidgetSize(
                  child: AlignedAnimatedSwitcher(
                    child: Text(
                      _description,
                      key: Key(_description),
                      style: cLightTextStyle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 16.0),

          CircularPercentIndicator(
            radius: 56.0,
            lineWidth: cLineSize,
            animation: true,
            animateFromLastPercent: true,
            animationDuration: cAnimationDuration.inMilliseconds,
            percent: _percent,
            center: Text(
              "${(_percent * 100).toStringAsFixed(0)}%",
              style: cTextStyle,
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: cChartBackgroundColor.withOpacity(0.35),
            progressColor: cChartBackgroundColor,
          )
        ],
      )
    );
  }
}