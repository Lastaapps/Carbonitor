import 'package:carbonitor/src/constants/router_destinations.dart';
import 'package:carbonitor/src/ui/homepage/homepage.dart';
import 'package:carbonitor/src/ui/login/login.dart';
import 'package:carbonitor/src/ui/timetable/timetable.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomeWidget());
      case AppRoutes.graphs:
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case AppRoutes.timetable:
        return MaterialPageRoute(builder: (_) => TimetableWidget());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginWidget());
      default:
        throw "Unknown destination ${settings.name}!";
    }
  }
}
