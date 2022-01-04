// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i8;

import '../screens/email_verification_screen.dart' as _i2;
import '../screens/forgot_password_screen.dart' as _i7;
import '../screens/login_screen.dart' as _i5;
import '../screens/register_screen.dart' as _i6;
import '../screens/temp_home_screen.dart' as _i3;
import '../screens/welcome_screen.dart' as _i4;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    WelcomeRouter.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.EmptyRouterPage());
    },
    EmailVerificationRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: _i2.EmailVerificationScreen());
    },
    TempHomeRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.TempHomeScreen());
    },
    WelcomeRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: _i4.WelcomeScreen());
    },
    LoginRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: _i5.LoginScreen());
    },
    RegisterRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: _i6.RegisterScreen());
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: _i7.ForgotPasswordScreen());
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(WelcomeRouter.name,
            path: '/empty-router-page',
            children: [
              _i1.RouteConfig(WelcomeRoute.name,
                  path: '', parent: WelcomeRouter.name),
              _i1.RouteConfig(LoginRoute.name,
                  path: 'login-screen', parent: WelcomeRouter.name),
              _i1.RouteConfig(RegisterRoute.name,
                  path: 'register-screen', parent: WelcomeRouter.name),
              _i1.RouteConfig(ForgotPasswordRoute.name,
                  path: 'forgot-password-screen', parent: WelcomeRouter.name)
            ]),
        _i1.RouteConfig(EmailVerificationRoute.name,
            path: '/email-verification-screen'),
        _i1.RouteConfig(TempHomeRoute.name, path: '/temp-home-screen')
      ];
}

/// generated route for
/// [_i1.EmptyRouterPage]
class WelcomeRouter extends _i1.PageRouteInfo<void> {
  const WelcomeRouter({List<_i1.PageRouteInfo>? children})
      : super(WelcomeRouter.name,
            path: '/empty-router-page', initialChildren: children);

  static const String name = 'WelcomeRouter';
}

/// generated route for
/// [_i2.EmailVerificationScreen]
class EmailVerificationRoute extends _i1.PageRouteInfo<void> {
  const EmailVerificationRoute()
      : super(EmailVerificationRoute.name, path: '/email-verification-screen');

  static const String name = 'EmailVerificationRoute';
}

/// generated route for
/// [_i3.TempHomeScreen]
class TempHomeRoute extends _i1.PageRouteInfo<void> {
  const TempHomeRoute() : super(TempHomeRoute.name, path: '/temp-home-screen');

  static const String name = 'TempHomeRoute';
}

/// generated route for
/// [_i4.WelcomeScreen]
class WelcomeRoute extends _i1.PageRouteInfo<void> {
  const WelcomeRoute() : super(WelcomeRoute.name, path: '');

  static const String name = 'WelcomeRoute';
}

/// generated route for
/// [_i5.LoginScreen]
class LoginRoute extends _i1.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: 'login-screen');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i6.RegisterScreen]
class RegisterRoute extends _i1.PageRouteInfo<void> {
  const RegisterRoute() : super(RegisterRoute.name, path: 'register-screen');

  static const String name = 'RegisterRoute';
}

/// generated route for
/// [_i7.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i1.PageRouteInfo<void> {
  const ForgotPasswordRoute()
      : super(ForgotPasswordRoute.name, path: 'forgot-password-screen');

  static const String name = 'ForgotPasswordRoute';
}
