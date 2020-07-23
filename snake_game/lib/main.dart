import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game/SnakePage.dart';
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

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit the App'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () => exit(0),
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Settings'),
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          icon: Icon(Icons.settings),
          backgroundColor: Colors.blueGrey,
          elevation: 0,
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
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
                  style: TextStyle(
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        color: Colors.blueGrey[700],
                        padding: EdgeInsets.all(30),
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/game'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EndPage extends StatefulWidget {
  @override
  _EndPageState createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  @override
  initState() {
    super.initState();
    if (highScore < score) setPref();
  }

  setPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('highscore', score);
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      //  _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit the App'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () => exit(0),
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Settings'),
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          icon: Icon(Icons.settings),
          backgroundColor: Colors.blueGrey,
          elevation: 0,
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
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
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 65,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  'Game Over!',
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                highScore < score
                    ? Text(
                        'New High Score!',
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      )
                    : SizedBox(),
                RichText(
                  text: TextSpan(
                      text: 'High Score: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                      children: [
                        TextSpan(
                          text: '${highScore > score ? highScore : score}',
                          style: TextStyle(
                            color: foodColor,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Your Score: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                      children: [
                        TextSpan(
                          text: '$score',
                          style: TextStyle(
                            color: foodColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        color: Colors.blueGrey[700],
                        padding: EdgeInsets.all(30),
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/game'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
