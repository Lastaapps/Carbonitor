import 'package:carbonitor/src/constants/router_destinations.dart';
import 'package:carbonitor/src/ui/router/app_router.dart';
import 'package:carbonitor/src/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter().generateRoute,
    );
  }
}
