import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snake_game/SnakePage.dart';

class EndPage extends StatelessWidget {
  const EndPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      //  _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to exit the App'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => exit(0),
                  child: const Text('Yes'),
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
          label: const Text('Settings'),
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          icon: const Icon(Icons.settings),
          backgroundColor: Colors.indigoAccent,
          elevation: 0,
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            color: Colors.indigoAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
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
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                highScore < score
                    ? const Text(
                        'New High Score!',
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      )
                    : const SizedBox(),
                RichText(
                  text: TextSpan(
                      text: border
                          ? 'High Score\nwith borders:  '
                          : 'High Score\nwithout borders:  ',
                      style: const TextStyle(
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
                      style: const TextStyle(
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
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        child: const Text(
                          'Play Game',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.indigoAccent[700]),
                        ),
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
