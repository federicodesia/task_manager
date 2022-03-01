import 'package:auto_route/auto_route.dart';
import 'package:boxy/flex.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/bottom_sheets/category_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/task_bottom_sheet.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/components/cards/category_card.dart';
import 'package:task_manager/components/header.dart';
import 'package:task_manager/components/lists/declarative_animated_list.dart';
import 'package:task_manager/components/lists/list_item_animation.dart';
import 'package:task_manager/components/main/app_bar.dart';
import 'package:task_manager/components/shimmer/shimmer_list.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/tab.dart';
import 'package:task_manager/components/main/floating_action_button.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/screens/home/today_tab.dart';
import 'package:task_manager/screens/home/upcoming_tab.dart';
import 'package:task_manager/theme/theme.dart';

import '../../constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final availableSpaceCubit = AvailableSpaceCubit();

    return BlocProvider(
      create: (_) => availableSpaceCubit,
      child: _HomeScreen(
        tabList: [
          MyTab(name: context.l10n.homeScreen_todayTab, content: TodayTab(availableSpaceCubit: availableSpaceCubit)),
          MyTab(name: context.l10n.homeScreen_upcomingTab, content: UpcomingTab(availableSpaceCubit: availableSpaceCubit)),
          MyTab(name: context.l10n.homeScreen_previousTab, content: Container()),
        ]
      ),
    );
  }
}

class _HomeScreen extends StatefulWidget{

  final List<MyTab> tabList;
  const _HomeScreen({required this.tabList});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> with TickerProviderStateMixin{

  late List<MyTab> tabList = widget.tabList;

  late PageController pageController;
  late TabController tabController;
  int currentTab = 0;

  double appBarHeight = 500.0;
  double contentHeight = 0.0;

  bool showFloatingActionButton = true;
  
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
    final customTheme = Theme.of(context).customTheme;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,

      floatingActionButton: AnimatedFloatingActionButton(
        visible: showFloatingActionButton,
        onPressed: () {
          ModalBottomSheet(
            title: context.l10n.bottomSheet_createTask,
            context: context,
            content: const TaskBottomSheet(),
          ).show();
        },
      ),

      body: LayoutBuilder(
        builder: (_, constraints){
          
          return AnimatedFloatingActionButtonScrollNotification(
            currentState: showFloatingActionButton,
            onChange: (value) => setState(() => showFloatingActionButton = value),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              slivers: [

                SliverAppBar(
                  collapsedHeight: appBarHeight,
                  flexibleSpace: WidgetSize(
                    onChange: (Size size){
                      setState(() => appBarHeight = size.height);
                      context.read<AvailableSpaceCubit>().setHeight(constraints.maxHeight - size.height - contentHeight);
                    },
                    child: MyAppBar(
                      header: context.l10n.homeScreen_header,
                      description: context.l10n.homeScreen_description,
                      onButtonPressed: () => AutoRouter.of(context).navigate(const ProfileRoute()),
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
                        Header(text: context.l10n.categories),
                        const SizedBox(height: cPadding),

                        BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (_, categoryState){
                            return WidgetSize(
                              onChange: (Size size) => setState(() {}),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(horizontal: cPadding),
                                  child: BoxyRow(
                                    children: [
                                      const Dominant(
                                        child: Opacity(
                                          opacity: 0,
                                          child: SizedBox(
                                            width: double.minPositive,
                                            child: CategoryCard(isShimmer: true)
                                          ),
                                        )
                                      ),

                                      AlignedAnimatedSwitcher(
                                        duration: cTransitionDuration,
                                        child: categoryState is CategoryLoadSuccess ? Row(
                                          children: [
                                            DeclarativeAnimatedList(
                                              scrollDirection: Axis.horizontal,
                                              items: categoryState.categories.toList(),
                                              equalityCheck: (Category a, Category b) => a.id == b.id,
                                              itemBuilder: (BuildContext context, Category item, int index, Animation<double> animation){
                                                return ListItemAnimation(
                                                  animation: animation,
                                                  axis: Axis.horizontal,
                                                  child: Container(
                                                    width: 148.0,
                                                    margin: const EdgeInsets.only(right: 12.0),
                                                    child: CategoryCard(
                                                      categoryId: item.id
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),

                                            AspectRatio(
                                              aspectRatio: 1.0,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  ModalBottomSheet(
                                                    title: context.l10n.bottomSheet_createCategory,
                                                    context: context,
                                                    content: const CategoryBottomSheet()
                                                  ).show();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: customTheme.backgroundColor,
                                                  padding: const EdgeInsets.all(8.0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(cBorderRadius),
                                                    side: BorderSide(color: customTheme.extraLightColor, width: 1.5)
                                                  ),
                                                  elevation: customTheme.elevation,
                                                  shadowColor: customTheme.shadowColor
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.add_rounded,
                                                      color: customTheme.lightColor,
                                                    ),
                                                    const SizedBox(height: 6.0),

                                                    Text(
                                                      context.l10n.addNewCategory_button,
                                                      style: customTheme.lightTextStyle,
                                                      textAlign: TextAlign.center,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 2.0),
                                                  ],
                                                )
                                              ),
                                            )
                                          ],
                                        ) : ShimmerList(
                                          minItems: 2,
                                          maxItems: 3,
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            width: 148.0,
                                            margin: const EdgeInsets.only(right: 12.0),
                                            child: const CategoryCard(isShimmer: true),
                                          )
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: cPadding),

                        // Tabs
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: cPadding),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                              ),
                              child: TabBar(
                                controller: tabController,
                                isScrollable: true,
                                physics: const BouncingScrollPhysics(),

                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorWeight: 0.0,
                                
                                indicator: DotIndicator(
                                  color: cPrimaryColor,
                                  distanceFromCenter: 20.0
                                ),
                                labelPadding: const EdgeInsets.only(right: 32.0),
                                indicatorPadding: const EdgeInsets.only(right: 32.0),

                                /*indicator: TabIndicatorDecoration(),
                                labelPadding: EdgeInsets.symmetric(horizontal: cPadding),*/
                                
                                labelStyle: customTheme.textStyle,
                                labelColor: customTheme.textColor,
                                unselectedLabelColor: customTheme.lightTextColor,

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
                    physics: const BouncingScrollPhysics(),
                    itemCount: tabList.length,
                    itemBuilder: (context, index){
                      
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: (constraints.maxHeight - appBarHeight - contentHeight).clamp(0.0, constraints.maxHeight)
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(cPadding),
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
          );
        },
      ),
    );
  }
}