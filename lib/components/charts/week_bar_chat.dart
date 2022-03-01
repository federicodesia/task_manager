import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/components/charts/week_bar_chart_group_data.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/theme/theme.dart';
import '../../constants.dart';
import '../aligned_animated_switcher.dart';

class WeekBarChart extends StatelessWidget{

  final double chartHeight;
  final String header;
  final int weekCompletedTasksCount;
  final int weekRemainingTasksCount;
  final Map<DateTime, int> weekTasks;
  final Map<DateTime, int> weekCompletedTasks;

  const WeekBarChart({
    Key? key, 
    this.chartHeight = 100,
    required this.header,
    required this.weekCompletedTasksCount,
    required this.weekRemainingTasksCount,
    required this.weekTasks,
    required this.weekCompletedTasks
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Container(
      decoration: BoxDecoration(
        color: customTheme.contentBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(cBorderRadius))
      ),
      padding: const EdgeInsets.all(cPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: customTheme.lightTextStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12.0),

          SizedBox(
            height: chartHeight,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  leftTitles: SideTitles(showTitles: false),
                  topTitles: SideTitles(showTitles: false),
                  rightTitles: SideTitles(showTitles: false),

                  bottomTitles: SideTitles(
                    showTitles: true,
                    margin: 12.0,
                    getTextStyles: (context, value) => customTheme.lightTextStyle,
                    getTitles: (double value) => weekTasks.keys.elementAt(value.toInt())
                      .formatLocalization(context, format: "E").substring(0, 1),
                  )
                ),

                barGroups: List.generate(weekTasks.length, (index){
                  return weekBarChartGroupData(
                    index: index,
                    height: weekCompletedTasks.values.elementAt(index).toDouble(),
                    backgroundHeight: weekTasks.values.elementAt(index).toDouble()
                  );
                })
              ),
              swapAnimationDuration: cAnimationDuration,
              swapAnimationCurve: Curves.linear,
            ),
          ),
          
          const SizedBox(height: 12.0),

          Stack(
            children: [
              Row(
                children: [
                  AlignedAnimatedSwitcher(
                    child: Text(
                      "$weekCompletedTasksCount ${context.l10n.enum_taskFilter_completed}",
                      key: Key("$weekCompletedTasksCount Completed"),
                      style: customTheme.boldTextStyle.copyWith(color: cPrimaryColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
              ),

              Row(
                children: [
                  // Invisible text to prevent repositioning of the  
                  // following text with variable character width fonts.
                  Opacity(
                    opacity: 0,
                    child: Text(
                      "100 " + context.l10n.enum_taskFilter_completed,
                      style: customTheme.boldTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(width: 8.0),
                  Expanded(
                    child: AlignedAnimatedSwitcher(
                      duration: cAnimationDuration,
                      child: Text(
                        "$weekRemainingTasksCount ${context.l10n.enum_taskFilter_remaining}",
                        key: Key("$weekRemainingTasksCount Remaining"),
                        style: customTheme.boldTextStyle.copyWith(color: cChartBackgroundColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}