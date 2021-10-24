import 'package:fl_chart/fl_chart.dart';
import '../../constants.dart';

BarChartGroupData weekBarChartGroupData({
  int index,
  double height,
  double backgroundHeight = 0.0
  }) {

  return BarChartGroupData(
    x: index, 
    barRods: [
      BarChartRodData(
        y: height,
        colors: [cChartPrimaryColor],
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: backgroundHeight,
          colors: [cChartBackgroundColor],
        )
      ),
    ]
  );
}