import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/blocs/upcoming_bloc/upcoming_bloc.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/repositories/category_repository.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'package:task_manager/repositories/user_repository.dart';
import 'package:task_manager/router/router.gr.dart';
import 'components/main/bottom_navigation_bar.dart';
import 'constants.dart';
import 'helpers/date_time_helper.dart';
import 'models/bottom_navigation_bar_item.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {

    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
          userRepository: UserRepository()
        ),
          
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {

            return MaterialApp.router(
              routerDelegate: AutoRouterDelegate.declarative(
                _appRouter,
                routes: (_) => [
                  if(authState.status == AuthStatus.authenticated) TempHomeRoute()
                  else if(authState.status == AuthStatus.waitingVerification) EmailVerificationRoute()
                  else WelcomeRouter()
                ],
              ),
              routeInformationParser: _appRouter.defaultRouteParser(includePrefixMatches: true),
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
            create: (context) =>
                TaskBloc(taskRepository: TaskRepository())..add(TaskLoaded())),
        BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(
                categoryRepository: CategoryRepository(),
                taskBloc: BlocProvider.of<TaskBloc>(context))
              ..add(CategoryLoaded())),
        BlocProvider<UpcomingBloc>(
            create: (context) =>
                UpcomingBloc(taskBloc: BlocProvider.of<TaskBloc>(context))
                  ..add(UpcomingLoaded())),
        BlocProvider<CalendarBloc>(
          create: (context) =>
              CalendarBloc(taskBloc: BlocProvider.of<TaskBloc>(context))
                ..add(CalendarLoaded(
                    startMonth:
                        DateTime(DateTime.now().year, DateTime.now().month - 1),
                    endMonth:
                        DateTime(DateTime.now().year, DateTime.now().month + 2),
                    selectedDate: getDate(DateTime.now()))),
        ),
      ],
      child: MaterialApp.router(
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser(),
          debugShowCheckedModeBanner: false),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(
        onChange: (index) {
          setState(() => selectedIndex = index);
        },
      ),
      backgroundColor: cBackgroundColor,
      body: SafeArea(
          child: IndexedStack(
        index: selectedIndex,
        children: List.generate(bottomNavigationBarItems.length, (index) {
          return bottomNavigationBarItems[index].child;
        }),
      )),
    );
  }
}
