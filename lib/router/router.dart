import 'package:auto_route/auto_route.dart';
import 'package:task_manager/router/wrappers/main_router_wrapper.dart';
import 'package:task_manager/screens/calendar_screen.dart';
import 'package:task_manager/screens/email_verification_screen.dart';
import 'package:task_manager/screens/forgot_password_email_verification_screen.dart';
import 'package:task_manager/screens/forgot_password_new_password_screen.dart';
import 'package:task_manager/screens/forgot_password_screen.dart';
import 'package:task_manager/screens/home/home_screen.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/screens/register_screen.dart';
import 'package:task_manager/screens/settings/notifications_screen.dart';
import 'package:task_manager/screens/settings/security/change_password_screen.dart';
import 'package:task_manager/screens/settings/security/security_screen.dart';
import 'package:task_manager/screens/settings/settings_screen.dart';
import 'package:task_manager/screens/splash_screen.dart';
import 'package:task_manager/screens/main_screen.dart';
import 'package:task_manager/screens/profile_screen.dart';
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
      name: "MainRouter",
      page: MainRouteWrapper,
      children: [
        AutoRoute(
          initial: true,
          page: MainScreen,
          children: [
            AutoRoute(page: HomeScreen),
            AutoRoute(page: CalendarScreen),
            AutoRoute(page: SettingsScreen),
          ]
        ),

        AutoRoute(page: SecurityScreen),
        AutoRoute(page: ChangePasswordScreen),

        AutoRoute(page: NotificationsScreen),
        AutoRoute(page: ProfileScreen),
      ]
    ),
  ],
)

class $AppRouter {}