import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/cubits/app_bar_cubit.dart';
import 'package:task_manager/cubits/available_space_cubit.dart';
import 'package:task_manager/cubits/main_context_cubit.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'components/main/bottom_navigation_bar.dart';
import 'constants.dart';
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
        BlocProvider<AppBarCubit>(create: (context) => AppBarCubit()..emit(1000.0)),
        BlocProvider<AvailableSpaceCubit>(create: (context) => AvailableSpaceCubit()),

        BlocProvider<CalendarBloc>(
          create: (context) => CalendarBloc(
            taskBloc: BlocProvider.of<TaskBloc>(context),
          ),
        )
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
    BlocProvider.of<MainContextCubit>(context).emit(context);
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