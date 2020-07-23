import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  void initState() {
    super.initState();
    nobox = 600;
    widthbox = 20;
    duration = Duration(milliseconds: 300);
    direction = 'down';
    foodPos();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _myAnimation = CurvedAnimation(curve: Curves.linear, parent: _controller);
  }

  void startGame() {
    // if (width > 400) {
    //   widthbox = 40;
    // }
    // duration = Duration(milliseconds: 300);
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
    });
  }

  int food;
  Random _random = Random();
  void foodPos() {
    food = _random.nextInt(nobox);
    while (snake.contains(food)) food = _random.nextInt(nobox);
    print(food);
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
        else
          foodPos();

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
                          // exit(0);
                          // setState(() {
                          //   initState();
                          // });
                          // Navigator.of(context)
                          //     .maybePop(Navigator.of(context).canPop());
                          Navigator.of(context).popAndPushNamed('/');
                        },
                        child: Text('Exit'))
                  ],
                  backgroundColor: Colors.black,
                  contentPadding: EdgeInsets.all(20),
                  title: Text('Score: ${snake.length}'),
                );
              });
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
          style: GoogleFonts.orbitron(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              '/', (route) => Navigator.canPop(context)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // autofocus: true,
        backgroundColor: Colors.blueGrey,
        elevation: 20,
        label: Text(
          _flag ? 'Start' : 'Pause',
          style: GoogleFonts.orbitron(),
        ),
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
              itemCount: nobox,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widthbox),
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Container(
                    // padding: EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: index == food ||
                              // index == snake[0] ||
                              index == snake.last
                          ? BorderRadius.circular(5)
                          : BorderRadius.circular(1),
                      child: Container(
                        color: snake.contains(index)
                            ? Colors.white
                            : index == food ? Colors.red : Colors.black54,
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
}
