import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:task_manager/components/header.dart';
import 'package:task_manager/components/tab_indicator.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/app_bar_cubit.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';

import '../../constants.dart';
import 'calendar_app_bar.dart';

class CalendarScreen extends StatefulWidget{

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with TickerProviderStateMixin{

  late TabController tabController;
  int currentTab = 0;
  double? tabHeight;
  
  @override
  void initState() {
    tabController = TabController(
      vsync: this,
      length: 7
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: LayoutBuilder(
        builder: (_, constraints){
          
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
                            onChange: (Size size) => BlocProvider.of<AppBarCubit>(context).emit(size.height),
                            child: CalendarAppBar()
                          )
                        ),

                        SliverToBoxAdapter(
                          child: WidgetSize(
                            onChange: (Size size) => BlocProvider.of<AvailableSpaceCubit>(context).emit(constraints.maxHeight - size.height),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

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
                                      indicatorWeight: 0.0,
                                      
                                      indicator: RectangularIndicator(
                                        topLeftRadius: 18.0,
                                        topRightRadius: 18.0,
                                        bottomLeftRadius: 18.0,
                                        bottomRightRadius: 18.0,
                                        color: cPrimaryColor
                                      ),
                                      labelPadding: EdgeInsets.all(cListItemPadding),
                                      padding: EdgeInsets.symmetric(horizontal: cPadding),

                                      tabs: List.generate(7, (index){
                                        DateTime dateTime = DateTime.now().add(Duration(days: index));

                                        return Tab(
                                          height: tabHeight ?? 100.0,
                                          child: WidgetSize(
                                            onChange: (Size size){
                                              setState(() => tabHeight = size.height);
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  DateFormat('d').format(dateTime),
                                                  style: cTextStyle.copyWith(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: index == currentTab ? cTextColor : cLightTextColor
                                                  ),
                                                ),
                                                SizedBox(height: 4.0),

                                                Text(
                                                  DateFormat('E').format(dateTime),
                                                  style: cLightTextStyle.copyWith(
                                                    fontSize: 13.0,
                                                    color: index == currentTab ? cTextColor : cLightTextColor
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                      onTap: (index) {
                                        setState(() => currentTab = index);
                                      }
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ),
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