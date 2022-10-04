// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game/desktop_binding.dart';

Color snakeColor = Colors.white;
Color boardColor = Colors.black;
Color foodColor = Colors.yellow;
Color borderColor = Colors.blue;
double score = 0;
int highScore = 0;
String elapsedTime = '';

bool border = false;

class SnakeGame extends StatefulWidget {
  const SnakeGame({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SnakeGame> with TickerProviderStateMixin {
  bool _flag = true;

  late Animation<double> _myAnimation;
  late AnimationController _controller;
  List<int> snake = [
    21,
    41,
    61,
    81,
    101,
  ];
  late int nobox;
  Duration duration = const Duration(milliseconds: 300);
  late int widthbox;
  String direction = 'down';
  late double width;

  Stopwatch watch = Stopwatch();
  late Timer timer;
  late int food;

  @override
  void initState() {
    super.initState();
    getPref();
    score = 0;
    nobox = 600;
    widthbox = 20;
    duration = const Duration(milliseconds: 300);
    direction = 'down';

    foodPos();
    resetWatch();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _myAnimation = CurvedAnimation(curve: Curves.linear, parent: _controller);
  }

  @override
  void dispose() {
    watch.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Snake Game',
          style: TextStyle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              '/', (route) => Navigator.canPop(context)),
        ),
      ),
      bottomSheet: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
        child: Text(
          '*If you pause the game,\nSpeed of Snake will increase',
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // autofocus: true,
        backgroundColor: Colors.indigoAccent,
        elevation: 20,
        label: Text(
          _flag ? 'Start' : elapsedTime,
          style: const TextStyle(),
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
        child: DesktopBindings(
          onUp: () => direction = 'up',
          onDown: () => direction = 'down',
          onLeft: () => direction = 'left',
          onRight: () => direction = 'right',
          onSpace: () {
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
            child: SizedBox(
              width: width > 400 ? 400 : width,
              child: GridView.builder(
                itemCount: nobox + widthbox,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widthbox),
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Container(
                      color: boardColor,
                      padding: snake.contains(index)
                          ? const EdgeInsets.all(1)
                          : const EdgeInsets.all(0),
                      child: ClipRRect(
                        borderRadius: index == food || index == snake.last
                            ? BorderRadius.circular(8)
                            : snake.contains(index)
                                ? BorderRadius.circular(3)
                                : BorderRadius.circular(1),
                        child: Container(
                          color: snake.contains(index)
                              ? snakeColor
                              : index == food
                                  ? foodColor
                                  : border
                                      ? isBorder(index)
                                          ? borderColor
                                          : boardColor
                                      : boardColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  void updateSnake() {
    if (!_flag) {
      setState(() async {
        if (direction == 'down') {
          if (snake.last > nobox) {
            snake.add(snake.last + widthbox - (nobox + widthbox));
          } else {
            snake.add(snake.last + widthbox);
          }
        } else if (direction == 'up') {
          if (snake.last < widthbox) {
            snake.add(snake.last - widthbox + (nobox + widthbox));
          } else {
            snake.add(snake.last - widthbox);
          }
        } else if (direction == 'right') {
          if ((snake.last + 1) % widthbox == 0) {
            snake.add(snake.last + 1 - widthbox);
          } else {
            snake.add(snake.last + 1);
          }
        } else if (direction == 'left') {
          if ((snake.last) % widthbox == 0) {
            snake.add(snake.last - 1 + widthbox);
          } else {
            snake.add(snake.last - 1);
          }
        }

        if (snake.last != food) {
          snake.removeAt(0);
        } else {
          score++;
          foodPos();
        }

        if (endGame()) {
          print('The end');
          setState(() {
            _flag = !_flag;
            score =
                (score * double.parse(elapsedTime.replaceFirst(':', '.')) * 100)
                        .floor() *
                    1.0;
            score = score / 100;
            // print(score);
          });
          if (highScore < score) {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            border
                ? prefs.setDouble('highscore1', score)
                : prefs.setDouble('highscore2', score);
            prefs.setBool('border', border);
          }
          Navigator.pushReplacementNamed(context, '/end');
        }
      });
    }
  }

  void getPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    highScore = border
        ? prefs.getDouble('highscore1')?.toInt() ?? 0
        : prefs.getDouble('highscore2')?.toInt() ?? 0;
    border = prefs.getBool('border') ?? false;
  }

  void startGame() {
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
    });
  }

  final Random _random = Random();
  void foodPos() {
    food = _random.nextInt(nobox);
    while (snake.contains(food)) {
      food = _random.nextInt(nobox);
    }
    while (isBorder(food)) {
      food = _random.nextInt(nobox);
    }
  }

  bool isBorder(int x) {
    for (int i = 0; i < widthbox; i++) {
      if (x == i) return true;
    }
    for (int i = nobox; i < nobox + widthbox; i++) {
      if (x == i) return true;
    }
    for (int i = 0; i < nobox; i = i + 20) {
      if (x == i) return true;
    }
    for (int i = widthbox - 1; i < widthbox + nobox; i = i + 20) {
      if (x == i) return true;
    }

    return false;
  }

  bool endGame() {
    if (border) {
      if (isBorder(snake.last)) {
        return true;
      } else {
        return false;
      }
    } else {
      for (int i = 0; i < snake.length - 1; i++) {
        if (snake.last == snake[i]) return true;
      }

      return false;
    }
  }

  startWatch() {
    watch.start();
    timer = Timer.periodic(const Duration(milliseconds: 100), updateTime);
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
