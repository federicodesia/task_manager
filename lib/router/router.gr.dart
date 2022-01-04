// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;

import '../screens/email_verification_screen.dart' as _i4;
import '../screens/forgot_password_screen.dart' as _i5;
import '../screens/login_screen.dart' as _i2;
import '../screens/register_screen.dart' as _i3;
import '../screens/temp_home_screen.dart' as _i6;
import '../screens/welcome_screen.dart' as _i1;

class AppRouter extends _i7.RootStackRouter {
  AppRouter([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    WelcomeRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.WelcomeScreen());
    },
    LoginRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: _i2.LoginScreen());
    },
    RegisterRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.RegisterScreen());
    },
    EmailVerificationRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: _i4.EmailVerificationScreen());
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: _i5.ForgotPasswordScreen());
    },
    TempHomeRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: _i6.TempHomeScreen());
    }
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(WelcomeRoute.name, path: '/welcome-screen'),
        _i7.RouteConfig(LoginRoute.name, path: '/login-screen'),
        _i7.RouteConfig(RegisterRoute.name, path: '/register-screen'),
        _i7.RouteConfig(EmailVerificationRoute.name,
            path: '/email-verification-screen'),
        _i7.RouteConfig(ForgotPasswordRoute.name,
            path: '/forgot-password-screen'),
        _i7.RouteConfig(TempHomeRoute.name, path: '/')
      ];
}

/// generated route for
/// [_i1.WelcomeScreen]
class WelcomeRoute extends _i7.PageRouteInfo<void> {
  const WelcomeRoute() : super(WelcomeRoute.name, path: '/welcome-screen');

  static const String name = 'WelcomeRoute';
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i7.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: '/login-screen');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i3.RegisterScreen]
class RegisterRoute extends _i7.PageRouteInfo<void> {
  const RegisterRoute() : super(RegisterRoute.name, path: '/register-screen');

  static const String name = 'RegisterRoute';
}

/// generated route for
/// [_i4.EmailVerificationScreen]
class EmailVerificationRoute extends _i7.PageRouteInfo<void> {
  const EmailVerificationRoute()
      : super(EmailVerificationRoute.name, path: '/email-verification-screen');

  static const String name = 'EmailVerificationRoute';
}

/// generated route for
/// [_i5.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i7.PageRouteInfo<void> {
  const ForgotPasswordRoute()
      : super(ForgotPasswordRoute.name, path: '/forgot-password-screen');

  static const String name = 'ForgotPasswordRoute';
}

/// generated route for
/// [_i6.TempHomeScreen]
class TempHomeRoute extends _i7.PageRouteInfo<void> {
  const TempHomeRoute() : super(TempHomeRoute.name, path: '/');

  static const String name = 'TempHomeRoute';
}
