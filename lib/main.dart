import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/blocs/upcoming_bloc/upcoming_bloc.dart';
import 'package:task_manager/cubits/app_bar_cubit.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/cubits/main_context_cubit.dart';
import 'package:task_manager/repositories/category_repository.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'components/main/bottom_navigation_bar.dart';
import 'constants.dart';
import 'helpers/date_time_helper.dart';
import 'models/bottom_navigation_bar_item.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainContextCubit>(create: (context) => MainContextCubit()),
        BlocProvider<TaskBloc>(create: (context) => TaskBloc(taskRepository: TaskRepository())..add(TaskLoaded())),
        
        BlocProvider<AppBarCubit>(create: (context) => AppBarCubit()..setHeight(1000.0)),
        BlocProvider<AvailableSpaceCubit>(create: (context) => AvailableSpaceCubit()),

        BlocProvider<CategoryBloc>(create: (context) => CategoryBloc(
          categoryRepository: CategoryRepository(),
          taskBloc: BlocProvider.of<TaskBloc>(context)
        )..add(CategoryLoaded())),

        BlocProvider<UpcomingBloc>(create: (context) => UpcomingBloc(
          taskBloc: BlocProvider.of<TaskBloc>(context)
        )..add(UpcomingLoaded())),

        BlocProvider<CalendarBloc>(
          create: (context) => CalendarBloc(
            taskBloc: BlocProvider.of<TaskBloc>(context)
          )..add(CalendarLoaded(
            startMonth: DateTime(DateTime.now().year, DateTime.now().month - 1),
            endMonth: DateTime(DateTime.now().year, DateTime.now().month + 2),
            selectedDate: getDate(DateTime.now())
          )),
        ),
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

class _MyHomePageState extends State<MyHomePage>{

  int selectedIndex = 0;

  @override
  void initState() {
    context.read<MainContextCubit>().setContext(context);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(
        onChange: (index){
          setState(() => selectedIndex = index);
        },
      ),
      
      backgroundColor: cBackgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: List.generate(bottomNavigationBarItems.length, (index){
            return bottomNavigationBarItems[index].child;
          }),
        )
      ),
    );
  }
}