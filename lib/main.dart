import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/repositories/user_repository.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/services/context_service.dart';
import 'package:task_manager/services/dialog_service.dart';
import 'package:task_manager/services/locator_service.dart';

void main() async{
  Paint.enableDithering = true;
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  HydratedBlocOverrides.runZoned(
    () => runApp(MyApp()),
    storage: storage,
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatoryKey = locator<DialogService>().navigatoryKey;
  late AppRouter _appRouter = AppRouter(navigatoryKey);

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_){
      final context = navigatoryKey.currentContext;
      if(context != null) locator<ContextService>().setContext(context);
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => UserRepository()),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>()
        ),
          
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {

            final authStatus = authState.status;

            return MaterialApp.router(
              routerDelegate: AutoRouterDelegate.declarative(
                _appRouter,
                routes: (_) => [
                  if(authStatus == AuthStatus.loading) SplashRoute()
                  else if(authStatus == AuthStatus.waitingVerification) EmailVerificationRoute()
                  else if(authStatus == AuthStatus.authenticated) MainRouter()
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

    /*return MultiBlocProvider(
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
    );*/

  }
}