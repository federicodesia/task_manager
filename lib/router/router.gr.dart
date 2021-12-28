// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;

import '../screens/login_screen.dart' as _i2;
import '../screens/register_screen.dart' as _i3;
import '../screens/welcome_screen.dart' as _i1;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    WelcomeRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.WelcomeScreen());
    },
    LoginRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: _i2.LoginScreen());
    },
    RegisterRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.RegisterScreen());
    }
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(WelcomeRoute.name, path: '/'),
        _i4.RouteConfig(LoginRoute.name, path: '/'),
        _i4.RouteConfig(RegisterRoute.name, path: '/')
      ];
}

/// generated route for
/// [_i1.WelcomeScreen]
class WelcomeRoute extends _i4.PageRouteInfo<void> {
  const WelcomeRoute() : super(WelcomeRoute.name, path: '/');

  static const String name = 'WelcomeRoute';
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i4.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: '/');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i3.RegisterScreen]
class RegisterRoute extends _i4.PageRouteInfo<void> {
  const RegisterRoute() : super(RegisterRoute.name, path: '/');

  static const String name = 'RegisterRoute';
}
