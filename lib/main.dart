import 'package:flutter/material.dart';
import 'package:task_manager/models/tab.dart';
import 'components/tab_indicator.dart';
import 'constants.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      length: tabList.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackgroundColor,
      body: Column(
        children: [

          // AppBar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(cAppBarBorderRadius),
                bottomRight: Radius.circular(cAppBarBorderRadius)
              ),
              gradient: RadialGradient(
                center: Alignment(1.25, -3.0),
                radius: 3.0,
                colors: [
                  cAppBarFirstColor,
                  cAppBarSecondColor,
                ]
              )
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(cPadding),
                    child: Row(
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
                              style: cLightHeaderTextStyle,
                            ),
                          ],
                        ),

                        // Profile
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18.0),
                          child: Container(
                            height: 48,
                            width: 48,
                            color: Color(0xFF252A34),
                            padding: EdgeInsets.all(10.0),
                            child: Image.asset(
                              "assets/icons/profile.png"
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Tabs
                  TabBar(
                    controller: tabController,
                    isScrollable: true,
                    physics: BouncingScrollPhysics(),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: TabIndicatorDecoration(),
                    indicatorPadding: EdgeInsets.symmetric(horizontal: cTabIndicatorPadding),
                    indicatorWeight: cTabIndicatorHeight,
                    labelStyle: cTabLabelStyle,
                    labelColor: cTabLabelColor,
                    unselectedLabelColor: cTabUnselectedLabelColor,
                    tabs: List.generate(tabList.length, (index){
                      return Tab(
                        text: tabList[index].text
                      );
                    }),
                  )
                ],
              ),
            ),
          ),

          // Tab contents
          Expanded(
            child: TabBarView(
              controller: tabController,
              physics: BouncingScrollPhysics(),
              children: List.generate(tabList.length, (index){
                return tabList[index].content;
              })
            ),
          )
        ],
      )
    );
  }
}