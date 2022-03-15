// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i22;

import '../screens/calendar_screen.dart' as _i19;
import '../screens/email_verification_screen.dart' as _i3;
import '../screens/forgot_password_email_verification_screen.dart' as _i9;
import '../screens/forgot_password_new_password_screen.dart' as _i10;
import '../screens/forgot_password_screen.dart' as _i8;
import '../screens/home/home_screen.dart' as _i18;
import '../screens/login_screen.dart' as _i6;
import '../screens/main_screen.dart' as _i11;
import '../screens/notifications_screen.dart' as _i20;
import '../screens/profile_screen.dart' as _i17;
import '../screens/register_screen.dart' as _i7;
import '../screens/settings/security/change_email_screen.dart' as _i14;
import '../screens/settings/security/change_email_verification_screen.dart'
    as _i15;
import '../screens/settings/security/change_password_screen.dart' as _i13;
import '../screens/settings/security/security_screen.dart' as _i12;
import '../screens/settings/settings_notifications_screen.dart' as _i16;
import '../screens/settings/settings_screen.dart' as _i21;
import '../screens/splash_screen.dart' as _i1;
import '../screens/welcome_screen.dart' as _i5;
import 'wrappers/main_router_wrapper.dart' as _i4;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i22.GlobalKey<_i22.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.SplashScreen());
    },
    WelcomeRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    EmailVerificationRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.EmailVerificationScreen());
    },
    MainRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.MainRouteWrapper());
    },
    WelcomeRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.WelcomeScreen());
    },
    LoginRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.LoginScreen());
    },
    RegisterRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.RegisterScreen());
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i8.ForgotPasswordScreen());
    },
    ForgotPasswordEmailVerificationRoute.name: (routeData) {
      final args = routeData.argsAs<ForgotPasswordEmailVerificationRouteArgs>();
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i9.ForgotPasswordEmailVerificationScreen(
              key: args.key, email: args.email));
    },
    ForgotPasswordNewPasswordRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i10.ForgotPasswordNewPasswordScreen());
    },
    MainRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i11.MainScreen());
    },
    SecurityRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i12.SecurityScreen());
    },
    ChangePasswordRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i13.ChangePasswordScreen());
    },
    ChangeEmailRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i14.ChangeEmailScreen());
    },
    ChangeEmailVerificationRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i15.ChangeEmailVerificationScreen());
    },
    SettingsNotificationsRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i16.SettingsNotificationsScreen());
    },
    ProfileRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i17.ProfileScreen());
    },
    HomeRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i18.HomeScreen());
    },
    CalendarRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i19.CalendarScreen());
    },
    NotificationsRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i20.NotificationsScreen());
    },
    SettingsRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i21.SettingsScreen());
    }
  };

  @override
  List<_i2.RouteConfig> get routes => [
        _i2.RouteConfig(SplashRoute.name, path: '/splash-screen'),
        _i2.RouteConfig(WelcomeRouter.name,
            path: '/empty-router-page',
            children: [
              _i2.RouteConfig(WelcomeRoute.name,
                  path: '', parent: WelcomeRouter.name),
              _i2.RouteConfig(LoginRoute.name,
                  path: 'login-screen', parent: WelcomeRouter.name),
              _i2.RouteConfig(RegisterRoute.name,
                  path: 'register-screen', parent: WelcomeRouter.name),
              _i2.RouteConfig(ForgotPasswordRoute.name,
                  path: 'forgot-password-screen', parent: WelcomeRouter.name),
              _i2.RouteConfig(ForgotPasswordEmailVerificationRoute.name,
                  path: 'forgot-password-email-verification-screen',
                  parent: WelcomeRouter.name),
              _i2.RouteConfig(ForgotPasswordNewPasswordRoute.name,
                  path: 'forgot-password-new-password-screen',
                  parent: WelcomeRouter.name)
            ]),
        _i2.RouteConfig(EmailVerificationRoute.name,
            path: '/email-verification-screen'),
        _i2.RouteConfig(MainRouter.name,
            path: '/main-route-wrapper',
            children: [
              _i2.RouteConfig(MainRoute.name,
                  path: '',
                  parent: MainRouter.name,
                  children: [
                    _i2.RouteConfig(HomeRoute.name,
                        path: 'home-screen', parent: MainRoute.name),
                    _i2.RouteConfig(CalendarRoute.name,
                        path: 'calendar-screen', parent: MainRoute.name),
                    _i2.RouteConfig(NotificationsRoute.name,
                        path: 'notifications-screen', parent: MainRoute.name),
                    _i2.RouteConfig(SettingsRoute.name,
                        path: 'settings-screen', parent: MainRoute.name)
                  ]),
              _i2.RouteConfig(SecurityRoute.name,
                  path: 'security-screen', parent: MainRouter.name),
              _i2.RouteConfig(ChangePasswordRoute.name,
                  path: 'change-password-screen', parent: MainRouter.name),
              _i2.RouteConfig(ChangeEmailRoute.name,
                  path: 'change-email-screen', parent: MainRouter.name),
              _i2.RouteConfig(ChangeEmailVerificationRoute.name,
                  path: 'change-email-verification-screen',
                  parent: MainRouter.name),
              _i2.RouteConfig(SettingsNotificationsRoute.name,
                  path: 'settings-notifications-screen',
                  parent: MainRouter.name),
              _i2.RouteConfig(ProfileRoute.name,
                  path: 'profile-screen', parent: MainRouter.name)
            ])
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashRoute extends _i2.PageRouteInfo<void> {
  const SplashRoute() : super(SplashRoute.name, path: '/splash-screen');

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class WelcomeRouter extends _i2.PageRouteInfo<void> {
  const WelcomeRouter({List<_i2.PageRouteInfo>? children})
      : super(WelcomeRouter.name,
            path: '/empty-router-page', initialChildren: children);

  static const String name = 'WelcomeRouter';
}

/// generated route for
/// [_i3.EmailVerificationScreen]
class EmailVerificationRoute extends _i2.PageRouteInfo<void> {
  const EmailVerificationRoute()
      : super(EmailVerificationRoute.name, path: '/email-verification-screen');

  static const String name = 'EmailVerificationRoute';
}

/// generated route for
/// [_i4.MainRouteWrapper]
class MainRouter extends _i2.PageRouteInfo<void> {
  const MainRouter({List<_i2.PageRouteInfo>? children})
      : super(MainRouter.name,
            path: '/main-route-wrapper', initialChildren: children);

  static const String name = 'MainRouter';
}

/// generated route for
/// [_i5.WelcomeScreen]
class WelcomeRoute extends _i2.PageRouteInfo<void> {
  const WelcomeRoute() : super(WelcomeRoute.name, path: '');

  static const String name = 'WelcomeRoute';
}

/// generated route for
/// [_i6.LoginScreen]
class LoginRoute extends _i2.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: 'login-screen');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i7.RegisterScreen]
class RegisterRoute extends _i2.PageRouteInfo<void> {
  const RegisterRoute() : super(RegisterRoute.name, path: 'register-screen');

  static const String name = 'RegisterRoute';
}

/// generated route for
/// [_i8.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i2.PageRouteInfo<void> {
  const ForgotPasswordRoute()
      : super(ForgotPasswordRoute.name, path: 'forgot-password-screen');

  static const String name = 'ForgotPasswordRoute';
}

/// generated route for
/// [_i9.ForgotPasswordEmailVerificationScreen]
class ForgotPasswordEmailVerificationRoute
    extends _i2.PageRouteInfo<ForgotPasswordEmailVerificationRouteArgs> {
  ForgotPasswordEmailVerificationRoute({_i22.Key? key, required String email})
      : super(ForgotPasswordEmailVerificationRoute.name,
            path: 'forgot-password-email-verification-screen',
            args: ForgotPasswordEmailVerificationRouteArgs(
                key: key, email: email));

  static const String name = 'ForgotPasswordEmailVerificationRoute';
}

class ForgotPasswordEmailVerificationRouteArgs {
  const ForgotPasswordEmailVerificationRouteArgs(
      {this.key, required this.email});

  final _i22.Key? key;

  final String email;

  @override
  String toString() {
    return 'ForgotPasswordEmailVerificationRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i10.ForgotPasswordNewPasswordScreen]
class ForgotPasswordNewPasswordRoute extends _i2.PageRouteInfo<void> {
  const ForgotPasswordNewPasswordRoute()
      : super(ForgotPasswordNewPasswordRoute.name,
            path: 'forgot-password-new-password-screen');

  static const String name = 'ForgotPasswordNewPasswordRoute';
}

/// generated route for
/// [_i11.MainScreen]
class MainRoute extends _i2.PageRouteInfo<void> {
  const MainRoute({List<_i2.PageRouteInfo>? children})
      : super(MainRoute.name, path: '', initialChildren: children);

  static const String name = 'MainRoute';
}

/// generated route for
/// [_i12.SecurityScreen]
class SecurityRoute extends _i2.PageRouteInfo<void> {
  const SecurityRoute() : super(SecurityRoute.name, path: 'security-screen');

  static const String name = 'SecurityRoute';
}

/// generated route for
/// [_i13.ChangePasswordScreen]
class ChangePasswordRoute extends _i2.PageRouteInfo<void> {
  const ChangePasswordRoute()
      : super(ChangePasswordRoute.name, path: 'change-password-screen');

  static const String name = 'ChangePasswordRoute';
}

/// generated route for
/// [_i14.ChangeEmailScreen]
class ChangeEmailRoute extends _i2.PageRouteInfo<void> {
  const ChangeEmailRoute()
      : super(ChangeEmailRoute.name, path: 'change-email-screen');

  static const String name = 'ChangeEmailRoute';
}

/// generated route for
/// [_i15.ChangeEmailVerificationScreen]
class ChangeEmailVerificationRoute extends _i2.PageRouteInfo<void> {
  const ChangeEmailVerificationRoute()
      : super(ChangeEmailVerificationRoute.name,
            path: 'change-email-verification-screen');

  static const String name = 'ChangeEmailVerificationRoute';
}

/// generated route for
/// [_i16.SettingsNotificationsScreen]
class SettingsNotificationsRoute extends _i2.PageRouteInfo<void> {
  const SettingsNotificationsRoute()
      : super(SettingsNotificationsRoute.name,
            path: 'settings-notifications-screen');

  static const String name = 'SettingsNotificationsRoute';
}

/// generated route for
/// [_i17.ProfileScreen]
class ProfileRoute extends _i2.PageRouteInfo<void> {
  const ProfileRoute() : super(ProfileRoute.name, path: 'profile-screen');

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i18.HomeScreen]
class HomeRoute extends _i2.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: 'home-screen');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i19.CalendarScreen]
class CalendarRoute extends _i2.PageRouteInfo<void> {
  const CalendarRoute() : super(CalendarRoute.name, path: 'calendar-screen');

  static const String name = 'CalendarRoute';
}

/// generated route for
/// [_i20.NotificationsScreen]
class NotificationsRoute extends _i2.PageRouteInfo<void> {
  const NotificationsRoute()
      : super(NotificationsRoute.name, path: 'notifications-screen');

  static const String name = 'NotificationsRoute';
}

/// generated route for
/// [_i21.SettingsScreen]
class SettingsRoute extends _i2.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings-screen');

  static const String name = 'SettingsRoute';
}
