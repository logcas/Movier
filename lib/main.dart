import 'package:flutter/material.dart';
import 'route.dart' as appRouter;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter deomo',
      initialRoute: '/',
      routes: appRouter.routes,
    );
  }
}
