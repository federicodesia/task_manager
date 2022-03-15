import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/theme.dart';

class DotTabBar extends StatelessWidget {

  final TabController? controller;
  final List<Widget> tabs;
  final Function(int)? onTap;
  final double? width;

  const DotTabBar({
    Key? key,
    this.controller,
    required this.tabs,
    this.onTap,
    this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    final tabBar = Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        physics: BouncingScrollPhysics(
          parent: width != null ? const AlwaysScrollableScrollPhysics() : null
        ),

        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 0.0,
        
        indicator: DotIndicator(
          color: cPrimaryColor,
          distanceFromCenter: 20.0
        ),

        padding: const EdgeInsets.symmetric(horizontal: cPadding),
        labelPadding: const EdgeInsets.only(right: 32.0),
        indicatorPadding: const EdgeInsets.only(right: 32.0),
        
        labelStyle: customTheme.textStyle,
        labelColor: customTheme.textColor,
        unselectedLabelColor: customTheme.lightTextColor,

        tabs: tabs,
        onTap: onTap
      ),
    );

    return width != null ? SizedBox(
      width: width,
      child: tabBar,
    ) : Align(
      alignment: Alignment.centerLeft,
      child: tabBar,
    );
  }
}