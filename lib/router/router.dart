import 'package:auto_route/auto_route.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/screens/register_screen.dart';
import 'package:task_manager/screens/welcome_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: WelcomeScreen, initial: true),
    AutoRoute(page: LoginScreen, initial: true),
    AutoRoute(page: RegisterScreen, initial: true),
  ],
)

class $AppRouter {}