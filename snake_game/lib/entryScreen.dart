import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:snake_game/SnakePage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    highScore = border
        ? prefs.getDouble('highscore1') == null
            ? 0
            : prefs.getDouble('highscore1')
        : prefs.getDouble('highscore2') == null
            ? 0
            : prefs.getDouble('highscore2');
    border = prefs.getBool('border') == null ? false : prefs.getBool('border');
    // int snakeColorCode = prefs.getInt('snakeColor') == null
    //     ? prefs.getInt('snakeColor')
    //     : snakeColor.hashCode;
    // int foodColorCode = prefs.getInt('foodColor') == null
    //     ? prefs.getInt('foodColor')
    //     : foodColor.hashCode;
    // int boardColorCode = prefs.getInt('boardColor') == null
    //     ? prefs.getInt('boardColor')
    //     : boardColor.hashCode;
    // snakeColor = Color(snakeColorCode);
    // foodColor = Color(foodColorCode);
    // boardColor = Color(boardColorCode);
  }

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
          label: Text(
            'Settings',
          ),
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          icon: Icon(
            Icons.settings,
          ),
          backgroundColor: Colors.indigoAccent,
          elevation: 0,
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        body: Center(
          child: Container(
            padding: EdgeInsets.all(25),
            color: Colors.indigoAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Classic Snake',
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
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
                            fontSize: 20,
                          ),
                        ),
                        color: Colors.indigoAccent[700],
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
    border
        ? prefs.setDouble('highscore1', score)
        : prefs.setDouble('highscore2', score);
    prefs.setBool('border', border);
    // prefs.setInt('snakeColor', snakeColor.hashCode);
    // prefs.setInt('foodColor', foodColor.hashCode);
    // prefs.setInt('boardColor', boardColor.hashCode);
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
          backgroundColor: Colors.indigoAccent,
          elevation: 0,
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        body: Center(
          child: Container(
            padding: EdgeInsets.all(25),
            color: Colors.indigoAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Classic Snake',
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  'Game Over! \nin $elapsedTime min',
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 35,
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
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      )
                    : SizedBox(),
                RichText(
                  text: TextSpan(
                      text: border
                          ? 'High Score\nwith borders:  '
                          : 'High Score\nwithout borders:  ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                      children: [
                        TextSpan(
                          text: '${highScore > score ? highScore : score}',
                          style: TextStyle(
                            color: foodColor,
                            fontSize: 25,
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
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                      children: [
                        TextSpan(
                          text: '$score',
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
                        color: Colors.indigoAccent[700],
                        padding: EdgeInsets.all(20),
                        onPressed: () {
                          elapsedTime = '';
                          Navigator.of(context).pushNamed('/game');
                        },
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
