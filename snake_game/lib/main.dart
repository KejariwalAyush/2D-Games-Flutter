import 'package:flutter/material.dart';
import 'package:snake_game/SnakePage.dart';
import 'package:snake_game/end_page.dart';
import 'package:snake_game/entryScreen.dart';
import 'package:snake_game/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        '/': (BuildContext context) => const MainScreen(),
        '/game': (BuildContext context) => const SnakeGame(),
        '/end': (BuildContext context) => const EndPage(),
        '/settings': (BuildContext context) => const Settings(),
      },
      // home:
    );
  }
}
