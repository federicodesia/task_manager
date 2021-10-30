import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/components/charts/week_bar_chart_group_data.dart';
import 'package:task_manager/models/task.dart';
import '../../constants.dart';
import '../aligned_animated_switcher.dart';

class WeekBarChart extends StatelessWidget{

  final double chartHeight;
  final String header;
  final List<Task> weekTasksList;

  WeekBarChart({
    this.chartHeight = 100,
    required this.header,
    required this.weekTasksList
  });

  final List<String> weekDays = ["M", "T", "W", "T", "F", "S", "S"];

  @override
  Widget build(BuildContext context) {

    int completedWeekTasks = weekTasksList.where((task) => task.completed).length;

    return Container(
      decoration: BoxDecoration(
        color: cCardBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(cBorderRadius))
      ),
      padding: EdgeInsets.all(cPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: cLightTextStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.0),

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
                    getTextStyles: (context, value) => cLightTextStyle,
                    getTitles: (double value) => weekDays[value.toInt()],
                  )
                ),

                barGroups: List.generate(7, (index){
                  final weekdayTasksList = weekTasksList.where((task) => task.dateTime.weekday - 1 == index);
                  return weekBarChartGroupData(
                    index: index,
                    height: weekdayTasksList.where((task) => task.completed).length.toDouble(),
                    backgroundHeight: weekdayTasksList.length.toDouble()
                  );
                })
              ),
              swapAnimationDuration: cAnimationDuration,
              swapAnimationCurve: Curves.linear,
            ),
          ),
          
          SizedBox(height: 12.0),

          Stack(
            children: [
              Row(
                children: [
                  AlignedAnimatedSwitcher(
                    child: Text(
                      "$completedWeekTasks Completed",
                      key: Key("$completedWeekTasks Completed"),
                      style: cTextStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        color: cChartPrimaryColor
                      ),
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
                      "100 Completed",
                      style: cTextStyle.copyWith(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(width: 8.0),
                  Expanded(
                    child: AlignedAnimatedSwitcher(
                      duration: cAnimationDuration,
                      child: Text(
                        "${weekTasksList.length - completedWeekTasks} Remaining",
                        key: Key("${weekTasksList.length - completedWeekTasks} Remaining"),
                        style: cTextStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          color: cChartBackgroundColor
                        ),
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