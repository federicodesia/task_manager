import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class DotIndicatorList extends StatelessWidget{

  final int count;
  final int selectedIndex;

  const DotIndicatorList({
    Key? key, 
    required this.count,
    required this.selectedIndex
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index){
        
        return AnimatedContainer(
          duration: cFastAnimationDuration,
          height: cDotSize,
          width: index == selectedIndex ? cSelectedDotSize : cDotSize,
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cDotSize),
            color: index == selectedIndex ? cPrimaryColor : Color.alphaBlend(customTheme.extraLightColor, customTheme.backgroundColor),
          ),
        );
      }),
    );
  }
}