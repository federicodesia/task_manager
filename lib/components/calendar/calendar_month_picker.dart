import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/constants.dart';

class CalendarMonthPicker extends StatefulWidget{

  final DateTime startDate;
  final DateTime endDate;
  final DateTime initialDate;

  CalendarMonthPicker({
    required this.startDate,
    required this.endDate,
    required this.initialDate
  });

  @override
  _CalendarMonthPickerState createState() => _CalendarMonthPickerState();
}

class _CalendarMonthPickerState extends State<CalendarMonthPicker>{

  late PageController pageController;
  double currentPage = 0.0;

  List<DateTime> monthList = [];
  
  @override
  void initState() {
    
    DateTime startDate = widget.startDate;
    DateTime endDate = widget.endDate;

    DateTime iterator;
    DateTime limit;

    if (startDate.isBefore(endDate))
    {
        iterator = DateTime(startDate.year, startDate.month);
        limit = endDate;
        
        while (iterator.isBefore(limit))
        {
          monthList.add(DateTime(iterator.year, iterator.month));
          iterator = DateTime(iterator.year, iterator.month + 1);

          print(monthList.last.toString());
        }
    }

    pageController = PageController();
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

    return Row(
      children: [

        IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          color: Colors.white.withOpacity(0.5),
          splashRadius: 24.0,
          onPressed: (){
            if(currentPage % 1 == 0) pageController.animateToPage(
              (currentPage).toInt() - 1,
              duration: cAnimationDuration,
              curve: Curves.easeInOut
            );
          },
        ),

        Expanded(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll){
              overscroll.disallowGlow();
              return false;
            },
            child: ExpandablePageView.builder(
              controller: pageController,
              physics: ClampingScrollPhysics(),
              itemCount: monthList.length,
              itemBuilder: (context, index){
                final double opacity = 1 - (currentPage - index).clamp(-1.0, 1.0).abs();

                return Opacity(
                  opacity: (4 * opacity - 3).clamp(0.0, 1.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      DateFormat('MMMM y').format(monthList[index]),
                      style: cTitleTextStyle.copyWith(fontSize: 14.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            ),
          ),
        ),

        IconButton(
          icon: Icon(Icons.chevron_right_rounded),
          color: Colors.white.withOpacity(0.5),
          splashRadius: 24.0,
          onPressed: (){
            if(currentPage % 1 == 0) pageController.animateToPage(
              (currentPage).toInt() + 1,
              duration: cAnimationDuration,
              curve: Curves.easeInOut
            );
          },
        ),
      ],
    );
  }
}