import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/notifications_cubit/notifications_cubit.dart';
import 'package:task_manager/blocs/settings_cubit/settings_cubit.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/services/context_service.dart';
import 'package:task_manager/services/dialog_service.dart';
import 'package:task_manager/services/locator_service.dart';
import 'package:task_manager/services/notification_service.dart';
import 'package:task_manager/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SettingsCubit()),

        BlocProvider(
          create: (context) => NotificationsCubit(
            settingsCubit: context.read<SettingsCubit>(),
            notificationService: locator<NotificationService>()
          ),
          lazy: false
        ),

        BlocProvider(
          create: (context) => AuthBloc(
            notificationsCubit: context.read<NotificationsCubit>(),
          )
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => context.read<AuthBloc>().baseRepository),
          RepositoryProvider(create: (context) => context.read<AuthBloc>().authRepository),
          RepositoryProvider(create: (context) => context.read<AuthBloc>().userRepository),
        ],
        child: _MyApp()
      ),
    );
  }
}

class _MyApp extends StatefulWidget {

  @override
  State<_MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp>{

  final navigatorKey = GlobalKey<NavigatorState>();
  late final AppRouter appRouter = AppRouter(navigatorKey);

  @override
  void initState() {
    locator<ContextService>().init(context);
    locator<DialogService>().init(navigatorKey);
    context.read<AuthBloc>().add(AuthLoaded());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {

        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {

            final authStatus = authState.status;

            return MaterialApp.router(
              theme: lightThemeData,
              darkTheme: darkThemeData,
              themeMode: settings.themeMode,

              routerDelegate: AutoRouterDelegate.declarative(
                appRouter,
                routes: (_) => [
                  if(authStatus == AuthStatus.loading) const SplashRoute()
                  else if(authStatus == AuthStatus.waitingVerification) const EmailVerificationRoute()
                  else if(authStatus == AuthStatus.authenticated) const MainRouter()
                  else const WelcomeRouter()
                ],
              ),
              routeInformationParser: appRouter.defaultRouteParser(includePrefixMatches: true),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                LocaleNamesLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              locale: settings.locale
            );
          },
        );
      }
    );
  }
}