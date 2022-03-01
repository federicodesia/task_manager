import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class MyBottomNavigationBar extends StatelessWidget{

  final TabsRouter tabsRouter;
  final List<IconData> icons;

  const MyBottomNavigationBar({
    Key? key, 
    required this.tabsRouter,
    required this.icons
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /*Container(
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
        ),*/

        Container(
          decoration: BoxDecoration(
            color: customTheme.contentBackgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            boxShadow: [
              BoxShadow(
                color: customTheme.shadowColor,
                blurRadius: 256.0
              )
            ]
          ),
          margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(icons.length, (index){
              return MyBottomNavigationBarIcon(
                icon: icons.elementAt(index),
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

class MyBottomNavigationBarIcon extends StatelessWidget{
  
  final IconData icon;
  final bool isSelected;
  final Function() onPressed;

  const MyBottomNavigationBarIcon({
    Key? key, 
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        IconButton(
          iconSize: 22.0,
          icon: AnimatedSwitcher(
            duration: cFastAnimationDuration,
            switchOutCurve: Curves.fastOutSlowIn,
            switchInCurve: Curves.fastOutSlowIn,
            child: Icon(
              icon,
              key: Key("${icon}KeyValue:$isSelected"),
              color: isSelected ? cPrimaryColor : customTheme.lightColor,
            )
          ),
          splashRadius: cSmallSplashRadius,
          color: isSelected ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.5),
          onPressed: onPressed,
        ),

        AnimatedContainer(
          duration: cTransitionDuration,
          height: 5.0,
          width: 8.0,
          decoration: BoxDecoration(
            color: isSelected ? cPrimaryColor : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(5.0))
          ),
        )
      ],
    );
  }
}