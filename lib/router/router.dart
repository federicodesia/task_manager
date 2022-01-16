import 'package:auto_route/auto_route.dart';
import 'package:task_manager/screens/email_verification_screen.dart';
import 'package:task_manager/screens/forgot_password_email_verification_screen.dart';
import 'package:task_manager/screens/forgot_password_new_password_screen.dart';
import 'package:task_manager/screens/forgot_password_screen.dart';
import 'package:task_manager/screens/home/home_screen.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/screens/register_screen.dart';
import 'package:task_manager/screens/splash_screen.dart';
import 'package:task_manager/screens/main_screen.dart';
import 'package:task_manager/screens/welcome_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[

    AutoRoute(page: SplashScreen),

    AutoRoute(
      name: "WelcomeRouter",
      page: EmptyRouterPage,
      children: [
        AutoRoute(page: WelcomeScreen, initial: true),
        AutoRoute(page: LoginScreen),
        AutoRoute(page: RegisterScreen),
        AutoRoute(page: ForgotPasswordScreen),
        AutoRoute(page: ForgotPasswordEmailVerificationScreen),
        AutoRoute(page: ForgotPasswordNewPasswordScreen),
      ]
    ),

    AutoRoute(page: EmailVerificationScreen),
    
    AutoRoute(
      name: "MainScreenRouter",
      page: MainScreen,
      children: [
        AutoRoute(page: HomeScreen)
      ]
    ),
  ],
)

class $AppRouter {}