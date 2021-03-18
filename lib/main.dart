import 'package:flutter/material.dart';
import 'package:oauth_sample/app_route_information_parser.dart';
import 'package:oauth_sample/app_router_delegate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppRouterDelegate _routerDelegate = AppRouterDelegate();
    AppRouteInformationParser _routeInformationParser =
        AppRouteInformationParser();
    return MaterialApp.router(
      title: 'Sample',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
      color: Colors.red,
      theme: ThemeData.dark().copyWith(
        primaryColor: Color.fromARGB(255, 33, 33, 33),
        accentColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
    );
  }
}
