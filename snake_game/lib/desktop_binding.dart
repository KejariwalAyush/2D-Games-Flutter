import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpIntent extends Intent {}

class DownIntent extends Intent {}

class LeftIntent extends Intent {}

class RightIntent extends Intent {}

class SpaceIntent extends Intent {}

class DesktopBindings extends StatelessWidget {
  const DesktopBindings({
    Key? key,
    required this.child,
    required this.onUp,
    required this.onDown,
    required this.onLeft,
    required this.onRight,
    required this.onSpace,
  }) : super(key: key);
  final Widget child;

  final Function onUp;
  final Function onDown;
  final Function onLeft;
  final Function onRight;
  final Function onSpace;

  @override
  Widget build(BuildContext context) {
    final _upKeySet = LogicalKeySet(
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.arrowUp,
    );
    final _downKeySet = LogicalKeySet(
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.arrowDown,
    );
    final _leftKeySet = LogicalKeySet(
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.arrowLeft,
    );
    final _rightKeySet = LogicalKeySet(
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.arrowRight,
    );
    final _spaceKeySet = LogicalKeySet(
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.space,
    );
    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {
        _upKeySet: UpIntent(),
        _downKeySet: DownIntent(),
        _rightKeySet: RightIntent(),
        _leftKeySet: LeftIntent(),
        _spaceKeySet: SpaceIntent(),
      },
      actions: {
        UpIntent: CallbackAction(onInvoke: ((intent) => onUp)),
        DownIntent: CallbackAction(onInvoke: ((intent) => onDown)),
        LeftIntent: CallbackAction(onInvoke: ((intent) => onLeft)),
        RightIntent: CallbackAction(onInvoke: ((intent) => onRight)),
        SpaceIntent: CallbackAction(onInvoke: ((intent) => onSpace)),
      },
      child: child,
    );
  }
}
