import 'package:flutter/material.dart';

import '../../constants.dart';

class MyBottomNavigationBarIcon{
  final String icon;
  final String selectedIcon;

  MyBottomNavigationBarIcon({this.icon, this.selectedIcon});
}

List<MyBottomNavigationBarIcon> icons = [
  MyBottomNavigationBarIcon(
    icon: "home_outlined",
    selectedIcon: "home_filled",
  ),
  MyBottomNavigationBarIcon(
    icon: "calendar_outlined",
    selectedIcon: "calendar_filled",
  ),
  MyBottomNavigationBarIcon(
    icon: "notification_outlined",
    selectedIcon: "notification_filled",
  ),
  MyBottomNavigationBarIcon(
    icon: "settings_outlined",
    selectedIcon: "settings_filled",
  )
];

class MyBottomNavigationBar extends StatefulWidget{
  MyBottomNavigationBar();

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar>{

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 2.0,
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
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(icons.length, (index){
              return MyBottomNavigationBarItem(
                icons: icons[index],
                isSelected: selectedIndex == index,
                onPressed: () {
                  setState(() => selectedIndex = index);
                }
              );
            }),
          ),
        )
      ],
    );
  }
}

class MyBottomNavigationBarItem extends StatelessWidget{

  final MyBottomNavigationBarIcon icons;
  final bool isSelected;
  final Function() onPressed;

  MyBottomNavigationBarItem({this.icons, this.isSelected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        IconButton(
          iconSize: 22.0,
          icon: SizedBox(
            height: 22.0,
            width: 22.0,
            child: AnimatedSwitcher(
              duration: cTransitionDuration,
              child: Opacity(
                key: UniqueKey(),
                opacity: isSelected ? 0.95 : 0.5,
                child: Image.asset("assets/icons/${isSelected ? icons.selectedIcon : icons.icon}.png")
              )
            ),
          ),
          splashRadius: 24.0,
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