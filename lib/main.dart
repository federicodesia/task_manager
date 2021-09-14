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
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18.0),
                        child: Container(
                          height: 48,
                          width: 48,
                          color: Color(0xFF252A34),
                          padding: EdgeInsets.all(cButtonPadding),
                          child: Image.asset(
                            "assets/icons/profile.png"
                          ),
                        ),
                      )
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
                            text: tabList[index].text
                          );
                        }),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: BouncingScrollPhysics(),
                children: List.generate(tabList.length, (index){
                  return tabList[index].content;
                })
              ),
            ),

            // Bottom Navigation Bar
            Container(
              padding: EdgeInsets.all(cPadding),
              decoration: BoxDecoration(
                color: cBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: cBackgroundColor,
                    spreadRadius: 16.0,
                    blurRadius: 8.0,
                  ),
                ],
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
                        primary: cPrimaryColor,
                        padding: EdgeInsets.all(cButtonPadding),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(cBorderRadius),
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
            ),
          ],
        ),
      ),
    );
  }
}