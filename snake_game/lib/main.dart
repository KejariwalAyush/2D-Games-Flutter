import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game/SnakePage.dart';

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
      },
      // home:
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(25),
          color: Colors.blueGrey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Classic Snake',
                overflow: TextOverflow.visible,
                style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 65,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    // alignment: Alignment.bottomRight,
                    child: RaisedButton(
                      child: Text(
                        'Play Game',
                        style: GoogleFonts.orbitron(
                          color: Colors.white60,
                          fontSize: 30,
                        ),
                      ),
                      color: Colors.blueGrey[700],
                      padding: EdgeInsets.all(30),
                      onPressed: () => Navigator.of(context).pushNamed('/game'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
