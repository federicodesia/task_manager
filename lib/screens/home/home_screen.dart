import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/components/cards/category_card.dart';
import 'package:task_manager/components/header.dart';
import 'package:task_manager/components/main/app_bar.dart';
import 'package:task_manager/models/tab.dart';
import 'package:task_manager/components/main/floating_action_button.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';

import '../../constants.dart';

class HomeScreen extends StatefulWidget{

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{

  late PageController pageController;
  late TabController tabController;
  int currentTab = 0;

  double appBarHeight = 500.0;
  double contentHeight = 0.0;
  
  @override
  void initState() {
    pageController = PageController();

    tabController = TabController(
      length: tabList.length,
      vsync: this,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Colors.transparent,
      
      floatingActionButton: AlignedAnimatedSwitcher(
        alignment: Alignment.bottomRight,
        duration: Duration(milliseconds: 150),
        child: tabList[currentTab].floatingActionButton ? MyFloatingActionButton(
          currentTab: currentTab,
        ) : Container(),
      ),

      body: LayoutBuilder(
        builder: (_, constraints){
          
          return CustomScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()
            ),
            slivers: [

              SliverAppBar(
                backgroundColor: cBackgroundColor,
                collapsedHeight: appBarHeight,
                flexibleSpace: WidgetSize(
                  onChange: (Size size){
                    setState(() => appBarHeight = size.height);
                    context.read<AvailableSpaceCubit>().setHeight(constraints.maxHeight - size.height - contentHeight);
                  },
                  child: MyAppBar(
                    header: "Hello 👋",
                    description: "Have a nice day!",
                    onButtonPressed: () {},
                  )
                )
              ),

              SliverToBoxAdapter(
                child: WidgetSize(
                  onChange: (Size size){
                    setState(() => contentHeight = size.height);
                    context.read<AvailableSpaceCubit>().setHeight(constraints.maxHeight - appBarHeight - size.height);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Header(
                        text: "Categories",
                        rightText: "See all",
                      ),
                      SizedBox(height: cPadding),

                      BlocBuilder<CategoryBloc, CategoryState>(
                        buildWhen: (previousState, currentState){
                          if(previousState is CategoryLoadSuccess && currentState is CategoryLoadSuccess){
                            if(previousState.categories.length != currentState.categories.length) return true;
                            return false;
                          }
                          return true;
                        },
                        builder: (_, categoryState){
                          return WidgetSize(
                            onChange: (Size size) => setState(() {}),
                            child: categoryState is CategoryLoadSuccess ? Align(
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: cPadding),
                                child: Row(
                                  children: List.generate(categoryState.categories.length, (index){
                                    bool lastItem = index == categoryState.categories.length - 1;

                                    return Container(
                                      width: 148.0,
                                      margin: EdgeInsets.only(right: lastItem ? 0.0 : 12.0),
                                      child: CategoryCard(
                                        categoryUuid: categoryState.categories[index].uuid
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ) : Container(),
                          );
                        },
                      ),

                      SizedBox(height: cPadding),

                      // Tabs
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: cPadding),
                        child: Align(
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
                              indicatorWeight: 0.0,
                              
                              indicator: DotIndicator(
                                color: cPrimaryColor,
                                distanceFromCenter: 20.0
                              ),
                              labelPadding: EdgeInsets.only(right: 32.0),
                              indicatorPadding: EdgeInsets.only(right: 32.0),

                              /*indicator: TabIndicatorDecoration(),
                              labelPadding: EdgeInsets.symmetric(horizontal: cPadding),*/
                              
                              labelStyle: cLightTextStyle,
                              labelColor: cTextColor,
                              unselectedLabelColor: cLightTextColor,

                              tabs: List.generate(tabList.length, (index){
                                return Tab(
                                  text: tabList[index].name
                                );
                              }),
                              onTap: (index){
                                pageController.animateToPage(
                                  index,
                                  duration: kTabScrollDuration,
                                  curve: Curves.ease
                                );
                              }
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: ExpandablePageView.builder(
                  controller: pageController,
                  physics: BouncingScrollPhysics(),
                  itemCount: tabList.length,
                  itemBuilder: (context, index){
                    
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: (constraints.maxHeight - appBarHeight - contentHeight).clamp(0.0, constraints.maxHeight)
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(cPadding),
                        child: tabList[index].content
                      ),
                    );
                  },
                  onPageChanged: (index){
                    setState(() => currentTab = index);
                    if(tabController.index != pageController.page){
                      tabController.animateTo(index);
                    }
                  },
                )
              ),
            ]
          );
        },
      ),
    );
  }
}