import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get currentContext => navigatorKey.currentContext;

  static Future<T?>? pushNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState?.pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?>? pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushReplacementNamed<T, TO>(routeName, result: result, arguments: arguments);
  }

  static Future<T?>? pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(newRouteName, predicate, arguments: arguments);
  }
}
