import 'package:flutter/material.dart';
import 'package:task_manager/models/tab.dart';
import 'components/tab_indicator.dart';
import 'constants.dart';
import 'tabs/today_tab.dart';

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

  // Tabs
  late TabController tabController;

  final List<MyTab> tabList = <MyTab>[
    MyTab("Today", TodayTab()),
    MyTab("Tasks", Container()),
    MyTab("Reminders", Container()),
    MyTab("Notes", Container()),
  ];

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
                              style: cLightTextStyle,
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
                    labelStyle: cLightTextStyle,
                    labelColor: cTextColor,
                    unselectedLabelColor: cTextColor.withOpacity(0.5),
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
          ),

          Container(
            padding: EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              //color: Color(0xFF202128),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home_rounded),
                  color: Color(0xFFCCCED2),
                  onPressed: () {},
                ),

                // Add button
                Container(
                  constraints: BoxConstraints.tightFor(width: 48.0, height: 48),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF7E41FF),
                      padding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.settings_rounded),
                  color: Color(0xFFCCCED2),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}