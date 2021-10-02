import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'bottom_sheets/modal_bottom_sheet.dart';
import 'components/rounded_button.dart';
import 'components/tab_indicator.dart';
import 'constants.dart';
import 'tabs/tabs.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(create: (context) => TaskBloc(taskRepository: TaskRepository())..add(TaskLoaded()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
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
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Tabs content
            Expanded(
              child: Stack(
                children: [
                  TabBarView(
                    controller: tabController,
                    physics: BouncingScrollPhysics(),
                    children: List.generate(tabList.length, (index){
                      return tabList[index].content;
                    })
                  ),

                  Container(
                    height: 0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: cBackgroundColor,
                          spreadRadius: 16.0,
                          blurRadius: 8.0,
                        ),
                      ],
                    )
                  )
                ],
              ),
            ),

            // Bottom Navigation Bar
            Container(
              padding: EdgeInsets.all(cPadding),
              decoration: BoxDecoration(
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
                  RoundedButton(
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                    ),
                    width: cButtonSize,
                    onPressed: () => ModalBottomSheet(
                      title: tabList[tabController.index].createTitle,
                      context: context,
                      content: tabList[tabController.index].bottomSheet
                    ).show(),
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