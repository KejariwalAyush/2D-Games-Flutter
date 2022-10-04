import 'dart:io';

import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to exit the App'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                ElevatedButton(
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
          label: const Text(
            'Settings',
          ),
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          icon: const Icon(
            Icons.settings,
          ),
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      // alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.all(30),
                      child: ElevatedButton(
                        child: const Text(
                          'Play Game',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.indigoAccent[700]),
                        ),
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
