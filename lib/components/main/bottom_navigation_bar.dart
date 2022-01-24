import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class MyBottomNavigationBar extends StatelessWidget{

  final TabsRouter tabsRouter;
  final List<MyBottomNavigationBarItem> items;

  MyBottomNavigationBar({
    required this.tabsRouter,
    required this.items
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
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
                customTheme.backgroundColor,
                cPrimaryColor.withOpacity(0.25),
                customTheme.backgroundColor
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
            children: List.generate(items.length, (index){
              return MyBottomNavigationBarIcon(
                item: items.elementAt(index),
                isSelected: tabsRouter.activeIndex == index,
                onPressed: () => index < tabsRouter.stack.length ? tabsRouter.setActiveIndex(index) : null
              );
            }),
          ),
        )
      ],
    );
  }
}

class MyBottomNavigationBarItem{
  final String icon;
  final String selectedIcon;

  MyBottomNavigationBarItem({
    required this.icon,
    required this.selectedIcon
  });
}

class MyBottomNavigationBarIcon extends StatelessWidget{
  
  final MyBottomNavigationBarItem item;
  final bool isSelected;
  final Function() onPressed;

  MyBottomNavigationBarIcon({
    required this.item,
    required this.isSelected,
    required this.onPressed,
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
              duration: cFastAnimationDuration,
              switchOutCurve: Curves.fastOutSlowIn,
              switchInCurve: Curves.fastOutSlowIn,
              child: Opacity(
                key: Key("MyBottomNavigationBarIcon: " + (isSelected ? item.selectedIcon : item.icon)),
                opacity: isSelected ? 0.9 : 0.5,
                child: Image.asset("assets/icons/${isSelected ? item.selectedIcon : item.icon}")
              )
            ),
          ),
          splashRadius: cBottomNavigationBarIconSize,
          color: isSelected ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.5),
          onPressed: onPressed,
        ),

        AnimatedContainer(
          duration: cTransitionDuration,
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