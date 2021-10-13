import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/components/responsive/widget_size.dart';
import 'package:task_manager/cubits/app_bar_cubit.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'components/main/app_bar.dart';
import 'components/main/bottom_navigation_bar.dart';
import 'components/main/floating_action_button.dart';
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
        BlocProvider<TaskBloc>(create: (context) => TaskBloc(taskRepository: TaskRepository())..add(TaskLoaded())),
        BlocProvider<AppBarCubit>(create: (context) => AppBarCubit()..emit(500)),
        BlocProvider<AvailableSpaceCubit>(create: (context) => AvailableSpaceCubit()),
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
  int currentTab = 0;

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
    floatingActionButton: MyFloatingActionButton(
      currentTab: currentTab,
      buildContext: context,
    ),
    bottomNavigationBar: MyBottomNavigationBar(),
    
    backgroundColor: cBackgroundColor,
    body: SafeArea(
      child: LayoutBuilder(
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
                            child: MyAppBar(
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
    ),
  );
  }
}