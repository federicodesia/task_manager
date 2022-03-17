import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/components/dot_tab_bar.dart';
import 'package:task_manager/components/main/app_bar.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/notification_type.dart';
import 'package:task_manager/theme/theme.dart';

class NotificationsScreen extends StatefulWidget{
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with TickerProviderStateMixin{

  late int tabCount = NotificationTypeFilter.values.length;
  late PageController pageController;
  late TabController tabController;
  int currentTab = 0;

  double appBarHeight = 500.0;
  double contentHeight = 0.0;

  @override
  void initState() {
    pageController = PageController();

    tabController = TabController(
      length: tabCount,
      vsync: this,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    final customTheme = Theme.of(context).customTheme;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){

            return CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
              ),
              slivers: [
                SliverAppBar(
                  backgroundColor: customTheme.backgroundColor,
                  collapsedHeight: appBarHeight,
                  flexibleSpace: WidgetSize(
                    onChange: (Size size){
                      setState(() => appBarHeight = size.height);
                    },
                    child: MyAppBar(
                      header: context.l10n.notificationsScreen_title,
                      description: context.l10n.notificationsScreen_description,
                      onButtonPressed: () {},
                    )
                  )
                ),

                SliverToBoxAdapter(
                  child: Column(
                    children: [

                      WidgetSize(
                        onChange: (Size size){
                          setState(() => contentHeight = size.height);
                        },
                        child: DotTabBar(
                          controller: tabController,
                          tabs: List.generate(tabCount, (index){
                            return Tab(text: NotificationTypeFilter.values.elementAt(index).nameLocalization(context));
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

                      ExpandablePageView.builder(
                        controller: pageController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: tabCount,
                        itemBuilder: (context, index){
                          
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: (constraints.maxHeight - appBarHeight - contentHeight)
                                .clamp(0.0, constraints.maxHeight)
                            ),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(cPadding),
                              child: Container()
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
                    ],
                  ),
                ),
              ],
            );
          }
        ),
      )
    );
  }
}