import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class SnakeGame extends StatefulWidget {
  SnakeGame({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SnakeGame> with TickerProviderStateMixin {
  bool _flag = true;

  Animation<double> _myAnimation;
  AnimationController _controller;
  List<int> snake = [
    0,
    20,
    40,
    60,
    80,
    100,
    120,
    140,
    160,
    180,
    200,
    220,
    240,
    260,
    280,
    300,
    320,
    340,
    360
  ];
  Duration duration = Duration(milliseconds: 300);
  String direction = 'down';
  @override
  void initState() {
    super.initState();
    duration = Duration(milliseconds: 300);
    snake = [1, 21, 41, 61, 81];
    direction = 'down';
    foodPos();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _myAnimation = CurvedAnimation(curve: Curves.linear, parent: _controller);
  }

  void startGame() {
    // if (snake == null)
    // snake = [1, 21, 41, 61, 81];
    // duration = Duration(milliseconds: 200);
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
    });
  }

  int food;
  Random _random = Random();
  void foodPos() {
    food = _random.nextInt(640);
    print(food);
  }

  bool endGame() {
    for (int i = 0; i < snake.length - 1; i++)
      if (snake.last == snake[i] || snake.last == 0) return true;
    return false;
  }

  void updateSnake() {
    if (!_flag)
      setState(() {
        if (direction == 'down') {
          if (snake.last > 640)
            snake.add(snake.last + 20 - 660);
          else
            snake.add(snake.last + 20);
        } else if (direction == 'up') {
          if (snake.last < 20)
            snake.add(snake.last - 20 + 660);
          else
            snake.add(snake.last - 20);
        } else if (direction == 'right') {
          if ((snake.last + 1) % 20 == 0)
            snake.add(snake.last + 1 - 20);
          else
            snake.add(snake.last + 1);
        } else if (direction == 'left') {
          if ((snake.last) % 20 == 0)
            snake.add(snake.last - 1 + 20);
          else
            snake.add(snake.last - 1);
        }

        if (endGame()) {
          print('The end');
          setState(() {
            _flag = !_flag;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  actions: [
                    new FlatButton(
                        onPressed: () {
                          exit(0);
                          // setState(() {
                          //   initState();
                          // });
                          // Navigator.of(context).pop();
                        },
                        child: Text('Exit'))
                  ],
                  backgroundColor: Colors.black54,
                  contentPadding: EdgeInsets.all(20),
                  title: Text('Score: ${snake.length}'),
                );
              });
        } else if (snake.last != food)
          snake.removeAt(0);
        else
          foodPos();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake Game'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        autofocus: true,
        backgroundColor: Colors.white54,
        elevation: 20,
        label: Text(_flag ? 'Start' : 'Pause'),
        onPressed: () {
          // print('flag changed');
          setState(() {
            if (_flag) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
            _flag = !_flag;
            startGame();
          });
        },
        isExtended: true,
        icon: AnimatedIcon(
            icon: AnimatedIcons.play_pause, progress: _myAnimation),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: Center(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            // setState(() {
            if (details.delta.dy > 0 && direction != 'up') {
              direction = 'down';
            }
            if (details.delta.dy < 0 && direction != 'down') {
              direction = 'up';
            }
            // print(direction);
          },
          onHorizontalDragUpdate: (details) {
            // setState(() {
            if (details.delta.dx > 0 && direction != 'left') {
              direction = 'right';
            }
            if (details.delta.dx < 0 && direction != 'right') {
              direction = 'left';
            }
            // print(direction);
          },
          child: Container(
            width: MediaQuery.of(context).size.width > 400
                ? 350
                : MediaQuery.of(context).size.width,
            child: GridView.builder(
              itemCount: 640,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 20),
              itemBuilder: (BuildContext context, int index) {
                if (!_flag) {
                  return Center(
                    child: Container(
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: snake.contains(index)
                              ? Colors.white
                              : index == food ? Colors.red : Colors.black54,
                        ),
                      ),
                    ),
                  );
                } else {
                  if (!snake.contains(index)) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    );
                  }

                  if (snake.contains(index))
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  if (food == index)
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
