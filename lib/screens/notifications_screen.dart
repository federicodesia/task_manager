import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/notifications_cubit/notifications_cubit.dart';
import 'package:task_manager/components/dot_tab_bar.dart';
import 'package:task_manager/components/lists/declarative_animated_list.dart';
import 'package:task_manager/components/lists/list_header.dart';
import 'package:task_manager/components/lists/list_item_animation.dart';
import 'package:task_manager/components/lists/notification_list_item.dart';
import 'package:task_manager/components/main/app_bar.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/dynamic_object.dart';
import 'package:task_manager/models/notification_data.dart';
import 'package:task_manager/models/notification_type.dart';
import 'package:task_manager/theme/theme.dart';

class NotificationsScreen extends StatefulWidget{
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with TickerProviderStateMixin{

  static const Map<NotificationTypeFilter, Widget> tabList = {
    NotificationTypeFilter.all : NotificationsScreenTab(null),
    NotificationTypeFilter.reminders : NotificationsScreenTab(NotificationType.reminder),
    NotificationTypeFilter.advertisements : NotificationsScreenTab(NotificationType.advertisement)
  };

  late PageController pageController;
  late TabController tabController;

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
                      onButtonPressed: () {
                        context.read<NotificationsCubit>().showTaskScheduleNotification("Prueba");
                      },
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
                          tabs: List.generate(tabList.length, (index){
                            return Tab(text: tabList.keys.elementAt(index).nameLocalization(context));
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
                        itemCount: tabList.length,
                        itemBuilder: (context, index){
                          
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: (constraints.maxHeight - appBarHeight - contentHeight)
                                .clamp(0.0, constraints.maxHeight)
                            ),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(cPadding),
                              child: tabList.values.elementAt(index)
                            ),
                          );
                        },
                        onPageChanged: (index){
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

class NotificationsScreenTab extends StatelessWidget{
  final NotificationType? typeFilter;

  const NotificationsScreenTab(
    this.typeFilter,
    { Key? key }
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (_, state){

        final now = DateTime.now();
        List<NotificationData> notifications = state.notifications;

        if(typeFilter != null){
          notifications = notifications.where((notification) {
            return notification.type == typeFilter;
          }).toList();
        }

        return DeclarativeAnimatedList(
          items: notifications.groupByDay,
          itemBuilder: (BuildContext buildContext, DynamicObject dynamicObject, int index, Animation<double> animation){
            final object = dynamicObject.object;

            return ListItemAnimation(
              animation: animation,
              child: object is NotificationData
                ? Padding(
                  padding: const EdgeInsets.only(bottom: cListItemSpace),
                  child: NotificationListItem(data: object),
                ) : object is DateTime
                  ? ListHeader(context.l10n.dateTime_daysAgo(now.dateDifference(object)))
                  : Container()
            );
          }
        );
      }
    );
  }
}