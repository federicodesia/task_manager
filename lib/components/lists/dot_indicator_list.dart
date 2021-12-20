import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class DotIndicatorList extends StatelessWidget{

  final int count;
  final int selectedIndex;

  DotIndicatorList({
    required this.count,
    required this.selectedIndex
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index){
        
        return AnimatedContainer(
          duration: cFastAnimationDuration,
          height: cDotSize,
          width: index == selectedIndex ? cDotSize * 2 : cDotSize,
          margin: EdgeInsets.symmetric(horizontal: 2.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cDotSize),
            color: index == selectedIndex ? cPrimaryColor : Color.alphaBlend(cLightGrayColor, cBackgroundColor),
          ),
        );
      }),
    );
  }
}