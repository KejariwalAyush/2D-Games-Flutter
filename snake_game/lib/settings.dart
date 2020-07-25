import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:snake_game/SnakePage.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color pickerColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('Borders'),
              subtitle: Text('On Enabling Borders, Snake will not bite itself'),
              trailing: Switch.adaptive(
                value: border,
                onChanged: (value) {
                  setState(() {
                    border = !border;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Change Snake Color'),
              trailing: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 20,
                  width: 20,
                  color: snakeColor,
                ),
              ),
              onTap: () => showDialog(
                context: context,
                child: AlertDialog(
                  title: const Text('Pick a color for Snake!'),
                  content: SingleChildScrollView(
                    child: MaterialPicker(
                      pickerColor: snakeColor,
                      onColorChanged: changeColor,
                      // showLabel: true, // only on portrait mode
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('Done'),
                      onPressed: () {
                        setState(() => snakeColor = pickerColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text('Change Food Color'),
              trailing: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 20,
                  width: 20,
                  color: foodColor,
                ),
              ),
              onTap: () => showDialog(
                context: context,
                child: AlertDialog(
                  title: const Text('Pick a color for Food!'),
                  content: SingleChildScrollView(
                    child: MaterialPicker(
                      pickerColor: foodColor,
                      onColorChanged: changeColor,
                      // showLabel: true, // only on portrait mode
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('Done'),
                      onPressed: () {
                        setState(() => foodColor = pickerColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text('Change Board Color'),
              trailing: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 20,
                  width: 20,
                  color: boardColor,
                ),
              ),
              onTap: () => showDialog(
                context: context,
                child: AlertDialog(
                  title: const Text('Pick a color for board!'),
                  content: SingleChildScrollView(
                    child: MaterialPicker(
                      pickerColor: boardColor,
                      onColorChanged: changeColor,
                      // showLabel: true, // only on portrait mode
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('Done'),
                      onPressed: () {
                        setState(() => boardColor = pickerColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  // void PickColor(Color currentColor) {
  //   showDialog(
  //     context: context,
  //     child: AlertDialog(
  //       title: const Text('Pick a color!'),
  //       content: SingleChildScrollView(
  //         // child: ColorPicker(
  //         //   pickerColor: pickerColor,
  //         //   onColorChanged: changeColor,
  //         //   showLabel: true,
  //         //   pickerAreaHeightPercent: 0.8,
  //         // ),
  //         // Use Material color picker:

  //         child: MaterialPicker(
  //           pickerColor: pickerColor,
  //           onColorChanged: changeColor,
  //           // showLabel: true, // only on portrait mode
  //         ),
  //         //
  //         // Use Block color picker:
  //         //
  //         // child: BlockPicker(
  //         //   pickerColor: currentColor,
  //         //   onColorChanged: changeColor,
  //         // ),
  //       ),
  //       actions: <Widget>[
  //         FlatButton(
  //           child: const Text('Got it'),
  //           onPressed: () {
  //             setState(() => snakeColor = pickerColor);
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  //   // return currentColor;
  // }
}
