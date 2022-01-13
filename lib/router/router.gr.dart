// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i11;

import '../screens/email_verification_screen.dart' as _i3;
import '../screens/forgot_password_email_verification_screen.dart' as _i9;
import '../screens/forgot_password_new_password_screen.dart' as _i10;
import '../screens/forgot_password_screen.dart' as _i8;
import '../screens/login_screen.dart' as _i6;
import '../screens/register_screen.dart' as _i7;
import '../screens/splash_screen.dart' as _i1;
import '../screens/temp_home_screen.dart' as _i4;
import '../screens/welcome_screen.dart' as _i5;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i11.GlobalKey<_i11.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.SplashScreen());
    },
    WelcomeRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    EmailVerificationRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.EmailVerificationScreen());
    },
    TempHomeRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i4.TempHomeScreen());
    },
    WelcomeRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i5.WelcomeScreen());
    },
    LoginRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i6.LoginScreen());
    },
    RegisterRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i7.RegisterScreen());
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i8.ForgotPasswordScreen());
    },
    ForgotPasswordEmailVerificationRoute.name: (routeData) {
      final args = routeData.argsAs<ForgotPasswordEmailVerificationRouteArgs>();
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i9.ForgotPasswordEmailVerificationScreen(email: args.email));
    },
    ForgotPasswordNewPasswordRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i10.ForgotPasswordNewPasswordScreen());
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
        _i2.RouteConfig(TempHomeRoute.name, path: '/temp-home-screen')
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
/// [_i4.TempHomeScreen]
class TempHomeRoute extends _i2.PageRouteInfo<void> {
  const TempHomeRoute() : super(TempHomeRoute.name, path: '/temp-home-screen');

  static const String name = 'TempHomeRoute';
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
  ForgotPasswordEmailVerificationRoute({required String email})
      : super(ForgotPasswordEmailVerificationRoute.name,
            path: 'forgot-password-email-verification-screen',
            args: ForgotPasswordEmailVerificationRouteArgs(email: email));

  static const String name = 'ForgotPasswordEmailVerificationRoute';
}

class ForgotPasswordEmailVerificationRouteArgs {
  const ForgotPasswordEmailVerificationRouteArgs({required this.email});

  final String email;

  @override
  String toString() {
    return 'ForgotPasswordEmailVerificationRouteArgs{email: $email}';
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
