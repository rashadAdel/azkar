// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:azkar/screens/Loadig.dart';
import 'package:azkar/screens/zekr.dart';
import 'package:azkar/screens/category.dart';
import 'package:page_transition/page_transition.dart';

class Router {
  static const initial = '/';
  static const zekr = '/zekr';
  static const category = '/category';
  static final navigator = ExtendedNavigator();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.initial:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => Loading(key: typedArgs),
          settings: settings,
        );
      case Router.zekr:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return PageTransition(
            child: Zekr(),
            key: typedArgs,
            type: PageTransitionType.size,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
            alignment: Alignment.center,
            settings: settings);
      case Router.category:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return PageTransition(
          child: Category(),
          type: PageTransitionType.fade,
          key: typedArgs,
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
