import 'package:flutter/material.dart';
import 'package:task_manager/models/tab.dart';

import '../../constants.dart';
import '../../components/rounded_button.dart';
import '../../components/tab_indicator.dart';

class HomeAppBar extends StatelessWidget{

  final TabController tabController;
  final Function(int) onTap;
  final List<MyTab> tabList;

  HomeAppBar({this.tabController, this.onTap, this.tabList});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(cPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello 👋",
                        style: cHeaderTextStyle,
                      ),

                      Text(
                        "Have a nice day!",
                        style: cLightTextStyle,
                      ),
                    ],
                  ),

                  // Profile
                  RoundedButton(
                    width: cButtonSize,
                    color: Color(0xFF252A34),
                    child: Image.asset(
                      "assets/icons/profile.png"
                    ),
                    onPressed: () {},
                  ),
                ],
              ),

              SizedBox(height: cPadding),

              // Tabs
              Align(
                alignment: Alignment.centerLeft,
                child: Theme(
                  data: ThemeData(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                  child: TabBar(
                    controller: tabController,
                    isScrollable: true,
                    physics: BouncingScrollPhysics(),

                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: TabIndicatorDecoration(),
                    labelPadding: EdgeInsets.symmetric(horizontal: cPadding),
                    
                    labelStyle: cLightTextStyle,
                    labelColor: cTextColor,
                    unselectedLabelColor: cLightTextColor,

                    tabs: List.generate(tabList.length, (index){
                      return Tab(
                        text: tabList[index].name
                      );
                    }),
                    onTap: onTap
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}