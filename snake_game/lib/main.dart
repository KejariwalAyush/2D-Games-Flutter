import 'package:flutter/material.dart';
import 'package:snake_game/SnakePage.dart';
import 'package:snake_game/entryScreen.dart';
import 'package:snake_game/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new MainScreen(),
        '/game': (BuildContext context) => new SnakeGame(),
        '/end': (BuildContext context) => new EndPage(),
        '/settings': (BuildContext context) => new Settings(),
      },
      // home:
    );
  }
}
