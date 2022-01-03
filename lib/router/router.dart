import 'package:auto_route/auto_route.dart';
import 'package:task_manager/screens/email_verification_screen.dart';
import 'package:task_manager/screens/forgot_password_screen.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/screens/register_screen.dart';
import 'package:task_manager/screens/welcome_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: WelcomeScreen, initial: true),
    AutoRoute(page: LoginScreen),
    AutoRoute(page: RegisterScreen),
    AutoRoute(page: EmailVerificationScreen),
    AutoRoute(page: ForgotPasswordScreen),
  ],
)

class $AppRouter {}