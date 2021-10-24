import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/components/charts/week_bar_chart_group_data.dart';
import 'package:task_manager/components/responsive/centered_list_widget.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/models/task.dart';

class WeekTab extends StatefulWidget{

  @override
  _WeekTabState createState() => _WeekTabState();
}

class _WeekTabState extends State<WeekTab>{

  Widget child;
  List<String> weekDays = ["M", "T", "W", "T", "F", "S", "S"];
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (_, state){

        if(state is TaskLoadSuccess){

          List<Task> weekTasksList = state.tasks.where((task){
            final weekday = DateTime.now().weekday - 1;
            final difference = task.dateTime.difference(DateTime.now()).inDays;
            return difference >= weekday * -1 && difference < 7 - weekday;
          }).toList();

          int completedWeekTasks = weekTasksList.where((task) => task.completed).length;

          child = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: cCardBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(cBorderRadius))
                ),
                padding: EdgeInsets.all(cPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tasks in this week",
                      style: cLightTextStyle,
                    ),
                    SizedBox(height: 12.0),

                    SizedBox(
                      height: 100,
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
                        swapAnimationDuration: Duration(milliseconds: 150),
                        swapAnimationCurve: Curves.linear,
                      ),
                    ),
                    
                    SizedBox(height: 12.0),

                    Row(
                      children: [
                        Text(
                          "$completedWeekTasks Completed",
                          style: cTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            color: cChartPrimaryColor
                          ),
                        ),
                        SizedBox(width: 18.0),
                        Text(
                          "${weekTasksList.length - completedWeekTasks} Remaining",
                          style: cTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            color: cChartBackgroundColor
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        }
        else{
          child = CenteredListWidget(
            child: CircularProgressIndicator(),
          );
        }

        return AlignedAnimatedSwitcher(
          child: child,
        );
      }
    );
  }
}