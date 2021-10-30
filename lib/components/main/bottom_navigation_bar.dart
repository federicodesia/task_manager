import 'package:flutter/material.dart';
import 'package:task_manager/models/bottom_navigation_bar_item.dart';

import '../../constants.dart';

class MyBottomNavigationBar extends StatefulWidget{

  final int initialSelectedIndex;
  final Function(int) onChange;

  MyBottomNavigationBar({
    this.initialSelectedIndex = 0,
    required this.onChange
  });

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar>{

  late int selectedIndex = widget.initialSelectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: cBottomNavigationBarSeparatorHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                cBackgroundColor,
                cPrimaryColor.withOpacity(0.25),
                cBackgroundColor
              ],
              stops: [
                0.1,
                0.5,
                0.9
              ]
            )
          ),
        ),

        Padding(
          padding: EdgeInsets.all(cBottomNavigationBarPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(bottomNavigationBarItems.length, (index){
              return MyBottomNavigationBarIcon(
                item: bottomNavigationBarItems[index],
                isSelected: selectedIndex == index,
                onPressed: () {
                  setState(() => selectedIndex = index);
                  widget.onChange(selectedIndex);
                }
              );
            }),
          ),
        )
      ],
    );
  }
}

class MyBottomNavigationBarIcon extends StatelessWidget{

  final MyBottomNavigationBarItem item;
  final bool isSelected;
  final Function() onPressed;

  MyBottomNavigationBarIcon({
    required this.item,
    required this.isSelected,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        IconButton(
          iconSize: cBottomNavigationBarIconSize,
          icon: SizedBox(
            height: cBottomNavigationBarIconSize,
            width: cBottomNavigationBarIconSize,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              switchOutCurve: Curves.fastOutSlowIn,
              switchInCurve: Curves.fastOutSlowIn,
              child: Opacity(
                key: UniqueKey(),
                opacity: isSelected ? 0.9 : 0.5,
                child: Image.asset("assets/icons/${isSelected ? item.selectedIcon : item.icon}.png")
              )
            ),
          ),
          splashRadius: cBottomNavigationBarIconSize,
          color: isSelected ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.5),
          onPressed: onPressed,
        ),

        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: 5.0,
          width: 5.0,
          decoration: BoxDecoration(
            color: isSelected ? cPrimaryColor : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(5.0))
          ),
        )
      ],
    );
  }
}