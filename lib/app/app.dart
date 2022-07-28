import 'package:flutter/material.dart';

import '../core/route_manager.dart';

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  // named constructor
  MyApp._internal();

  int appState = 0;

  static final MyApp _instance =
      MyApp._internal(); // singleton or single instance

  factory MyApp() => _instance; // factory

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RouteGenerator routeGenerator = RouteGenerator();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: routeGenerator.getRoute,
      initialRoute: Routes.splashRoute,
    );
  }
}
