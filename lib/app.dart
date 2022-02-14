import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/cubits/theme_cubit.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/repositories/base_repository.dart';
import 'package:task_manager/repositories/user_repository.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/services/context_service.dart';
import 'package:task_manager/services/dialog_service.dart';
import 'package:task_manager/services/locator_service.dart';
import 'package:task_manager/theme/theme.dart';

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
        RepositoryProvider(create: (context) => BaseRepository()),
        RepositoryProvider(create: (context) => AuthRepository(base: context.read<BaseRepository>())),
        RepositoryProvider(create: (context) => UserRepository(base: context.read<BaseRepository>())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              userRepository: context.read<UserRepository>()
            )..add(AuthLoaded()),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {

            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {

                final authStatus = authState.status;

                return MaterialApp.router(
                  theme: lightThemeData,
                  darkTheme: darkThemeData,
                  themeMode: themeMode,

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
            );
          }
        ),
      )
    );
  }
}