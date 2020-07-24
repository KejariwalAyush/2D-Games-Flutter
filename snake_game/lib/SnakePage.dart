import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SnakeGame extends StatefulWidget {
  SnakeGame({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Color snakeColor = Colors.white;
Color boardColor = Colors.black;
Color foodColor = Colors.yellow;
int score = 0;
int highScore = 0;
String elapsedTime = '';

class _MyHomePageState extends State<SnakeGame> with TickerProviderStateMixin {
  bool _flag = true;

  Animation<double> _myAnimation;
  AnimationController _controller;
  List<int> snake = [
    21,
    41,
    61,
    81,
    101,
  ];
  int nobox;
  Duration duration = Duration(milliseconds: 300);
  var widthbox;
  String direction = 'down';
  var width;

  Stopwatch watch = new Stopwatch();
  Timer timer;

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    score = 0;
    nobox = 600;
    widthbox = 20;
    duration = Duration(milliseconds: 300);
    direction = 'down';
    foodPos();
    getPref();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _myAnimation = CurvedAnimation(curve: Curves.linear, parent: _controller);
  }

  getPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    highScore =
        prefs.getInt('highscore') == null ? 0 : prefs.getInt('highscore');
  }

  void startGame() {
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
    });
  }

  int food;
  Random _random = Random();
  void foodPos() {
    food = _random.nextInt(nobox);
    while (snake.contains(food)) food = _random.nextInt(nobox);
  }

  bool endGame() {
    for (int i = 0; i < snake.length - 1; i++)
      if (snake.last == snake[i]) return true;
    return false;
  }

  void updateSnake() {
    if (!_flag)
      setState(() {
        if (direction == 'down') {
          if (snake.last > nobox)
            snake.add(snake.last + widthbox - (nobox + widthbox));
          else
            snake.add(snake.last + widthbox);
        } else if (direction == 'up') {
          if (snake.last < widthbox)
            snake.add(snake.last - widthbox + (nobox + widthbox));
          else
            snake.add(snake.last - widthbox);
        } else if (direction == 'right') {
          if ((snake.last + 1) % widthbox == 0)
            snake.add(snake.last + 1 - widthbox);
          else
            snake.add(snake.last + 1);
        } else if (direction == 'left') {
          if ((snake.last) % widthbox == 0)
            snake.add(snake.last - 1 + widthbox);
          else
            snake.add(snake.last - 1);
        }

        if (snake.last != food)
          snake.removeAt(0);
        else {
          score++;
          foodPos();
        }

        if (endGame()) {
          print('The end');
          setState(() {
            _flag = !_flag;
          });
          Navigator.pushReplacementNamed(context, '/end');
          // showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return AlertDialog(
          //         actions: [
          //           new FlatButton(
          //               onPressed: () {
          //                 Navigator.of(context).popAndPushNamed('/');
          //               },
          //               child: Text('Return to Home Screen'))
          //         ],
          //         backgroundColor: boardColor,
          //         contentPadding: EdgeInsets.all(20),
          //         title: Text('Score: $score'),
          //       );
          //     });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Snake Game',
          style: TextStyle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              '/', (route) => Navigator.canPop(context)),
        ),
      ),
      bottomSheet: Text(
        '*If you pause the game, Speed of Snake will increase',
        overflow: TextOverflow.visible,
        // textAlign: TextAlign.end,
      ),
      floatingActionButton: FloatingActionButton.extended(
        // autofocus: true,
        backgroundColor: Colors.blueGrey,
        elevation: 20,
        label: Text(
          _flag ? 'Start' : '$elapsedTime',
          style: TextStyle(),
        ),
        onPressed: () {
          // print('flag changed');
          setState(() {
            if (_flag) {
              _controller.forward();
              startWatch();
            } else {
              _controller.reverse();
              stopWatch();
            }
            _flag = !_flag;
            startGame();
          });
        },
        isExtended: true,
        icon: AnimatedIcon(
            icon: AnimatedIcons.play_pause, progress: _myAnimation),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            width: width,
            child: GridView.builder(
              itemCount: nobox + widthbox,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widthbox),
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Container(
                    color: boardColor,
                    padding: snake.contains(index)
                        ? EdgeInsets.all(1)
                        : EdgeInsets.all(0),
                    child: ClipRRect(
                      borderRadius: index == food || index == snake.last
                          ? BorderRadius.circular(8)
                          : snake.contains(index)
                              ? BorderRadius.circular(3)
                              : BorderRadius.circular(1),
                      child: Container(
                        color: snake.contains(index)
                            ? snakeColor
                            : index == food ? foodColor : boardColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  startWatch() {
    watch.start();
    timer = new Timer.periodic(new Duration(milliseconds: 100), updateTime);
  }

  stopWatch() {
    watch.stop();
    setTime();
  }

  resetWatch() {
    watch.reset();
    setTime();
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  transformMilliSeconds(int milliseconds) {
    //Thanks to Andrew
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }
}
