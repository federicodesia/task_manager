import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/app_bar_cubit.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'components/rounded_button.dart';
import 'components/tab_indicator.dart';
import 'constants.dart';
import 'models/tab.dart';
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
        BlocProvider<TaskBloc>(create: (context) => TaskBloc(taskRepository: TaskRepository())..add(TaskLoaded())),
        BlocProvider<AppBarCubit>(create: (context) => AppBarCubit()..emit(500)),
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

  PageController pageController;
  TabController tabController;

  @override
  void initState() {
    MyTabs().init(context);
    
    pageController = PageController();

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
      child: LayoutBuilder(
        builder: (context, constraints){

          return BlocBuilder<AppBarCubit, double>(
            builder: (context, state) {
              return CustomScrollView(
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()
                ),
                slivers: [
                  SliverAppBar(
                    backgroundColor: cBackgroundColor,
                    collapsedHeight: state,
                    flexibleSpace: WidgetSize(
                      onChange: (Size size){
                        BlocProvider.of<AppBarCubit>(context).emit(size.height);
                      },
                      child: buildAppBar(
                        tabController,
                        (index){
                          pageController.animateToPage(
                            index,
                            duration: kTabScrollDuration,
                            curve: Curves.ease
                          );
                        },
                        tabList
                      )
                    )
                  ),

                  SliverToBoxAdapter(
                    child: ExpandablePageView.builder(
                      controller: pageController,
                      physics: BouncingScrollPhysics(),
                      itemCount: tabList.length,
                      itemBuilder: (context, index){
                        
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: (constraints.maxHeight - state).clamp(0, constraints.maxHeight)
                          ),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(cPadding),
                            child: tabList[index].content
                          ),
                        );
                      },
                      onPageChanged: (index){
                        if(tabController.index != pageController.page){
                          tabController.animateTo(index);
                        }
                      },
                    ),
                  ),
                ]
              );
            },
          );
        },
      ),
    ),
  );
  }
}

Widget buildAppBar(TabController tabController, Function(int) onTap, List<MyTab> tabList){
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