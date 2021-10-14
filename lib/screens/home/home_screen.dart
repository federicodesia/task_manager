import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/models/tab.dart';
import 'package:task_manager/screens/home/home_app_bar.dart';
import 'package:task_manager/components/main/floating_action_button.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/app_bar_cubit.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';

import '../../constants.dart';

class HomeScreen extends StatefulWidget{

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{

  PageController pageController;
  TabController tabController;
  int currentTab = 0;
  
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
          BlocProvider.of<AvailableSpaceCubit>(context).emit(constraints.maxHeight);
          
          return BlocBuilder<AppBarCubit, double>(
            builder: (_, state) {
              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
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
                            child: HomeAppBar(
                              tabController: tabController,
                              onTap: (index){
                                pageController.animateToPage(
                                  index,
                                  duration: kTabScrollDuration,
                                  curve: Curves.ease
                                );
                              },
                              tabList: tabList
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
                                  padding: EdgeInsets.fromLTRB(cPadding, 12.0, cPadding, cPadding),
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
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}