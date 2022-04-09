import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/theme/theme.dart';

class CalendarMonthPicker extends StatefulWidget{

  final List<DateTime> months;
  final DateTime initialMonth;
  final Function(DateTime)? onChanged;

  const CalendarMonthPicker({
    Key? key, 
    required this.months,
    required this.initialMonth,
    this.onChanged
  }) : super(key: key);

  @override
  _CalendarMonthPickerState createState() => _CalendarMonthPickerState();
}

class _CalendarMonthPickerState extends State<CalendarMonthPicker>{

  late PageController pageController;
  late List<DateTime> monthList = widget.months;
  late double currentPage;
  
  @override
  void initState() {
    int initialPage = monthList.indexOf(widget.initialMonth.ignoreTime.copyWith(day: 1));
    initialPage = initialPage != -1 ? initialPage : 0;

    currentPage = initialPage.toDouble();
    pageController = PageController(
      initialPage: initialPage
    );
    pageController.addListener(onScroll);

    super.initState();
  }

  @override
  void dispose() {
    pageController.removeListener(onScroll);
    super.dispose();
  }
  
  void onScroll(){
    setState(() => currentPage = pageController.page!);
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Row(
      children: [

        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          color: customTheme.lightColor,
          splashRadius: cSmallSplashRadius,
          onPressed: (){
            if(currentPage % 1 == 0) {
              pageController.animateToPage(
                (currentPage).toInt() - 1,
                duration: cAnimationDuration,
                curve: Curves.easeInOut
              );
            }
          },
        ),

        Expanded(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll){
              overscroll.disallowIndicator();
              return false;
            },
            child: ExpandablePageView.builder(
              controller: pageController,
              physics: const ClampingScrollPhysics(),
              itemCount: monthList.length,
              itemBuilder: (context, index){
                final double opacity = 1 - (currentPage - index).clamp(-1.0, 1.0).abs();

                return Opacity(
                  opacity: (4 * opacity - 3).clamp(0.0, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      monthList[index].format(context, "MMMM y"),
                      style: customTheme.boldTextStyle,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              onPageChanged: (index){
                if(widget.onChanged != null) widget.onChanged!(monthList[index]);
              },
            ),
          ),
        ),

        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          color: customTheme.lightColor,
          splashRadius: cSmallSplashRadius,
          onPressed: (){
            if(currentPage % 1 == 0) {
              pageController.animateToPage(
                (currentPage).toInt() + 1,
                duration: cAnimationDuration,
                curve: Curves.easeInOut
              );
            }
          },
        ),
      ],
    );
  }
}