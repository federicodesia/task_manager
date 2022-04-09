import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/components/responsive/animated_widget_size.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/theme/theme.dart';

class ProgressSummary extends StatelessWidget{

  final String header;
  final int completed;
  final int total;

  const ProgressSummary({
    Key? key, 
    required this.header,
    required this.completed,
    required this.total
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    String _description;
    if(completed == 0) {
      _description = context.l10n.progressSummary_description;
    }
    else if(completed == total) {
      _description = context.l10n.progressSummary_finished_description;
    }
    else {
      _description = context.l10n.progressSummary_inProgress_description(completed, total);
    }

    double _percent = total > 0 ? completed / total : 0.0;

    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(cBorderRadius)),
      elevation: customTheme.elevation,
      shadowColor: customTheme.shadowColor,
      child: Container(
        decoration: BoxDecoration(
          color: customTheme.contentBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(cBorderRadius))
        ),
        padding: const EdgeInsets.all(cPadding),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    header,
                    style: customTheme.boldTextStyle,
                    maxLines: 3
                  ),
                  const SizedBox(height: 8.0),

                  AnimatedWidgetSize(
                    child: AlignedAnimatedSwitcher(
                      child: Text(
                        _description,
                        key: Key(_description),
                        style: customTheme.lightTextStyle,
                        maxLines: 3
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16.0),

            CircularPercentIndicator(
              radius: 32.0,
              lineWidth: cLineSize,
              animation: true,
              animateFromLastPercent: true,
              animationDuration: cAnimationDuration.inMilliseconds,
              percent: _percent,
              center: Text(
                "${(_percent * 100).toStringAsFixed(0)}%",
                style: customTheme.textStyle,
                maxLines: 1,
              ),
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: cChartBackgroundColor,
              progressColor: cPrimaryColor,
            )
          ],
        )
      ),
    );
  }
}