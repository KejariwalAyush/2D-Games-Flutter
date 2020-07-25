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
        backgroundColor: Colors.indigoAccent,
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
            colorChangeTile(
              title: 'Change Snake Color',
              alertTitle: 'Select Snake Color',
              alertButtonText: 'Select',
              selectedColor: snakeColor,
              onPressed: () {
                setState(() => snakeColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
            colorChangeTile(
              title: 'Change Food Color',
              alertTitle: 'Select Food Color',
              alertButtonText: 'Select',
              selectedColor: foodColor,
              onPressed: () {
                setState(() => foodColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
            colorChangeTile(
              title: 'Change Border Color',
              alertTitle: 'Select Border Color',
              alertButtonText: 'Select',
              selectedColor: borderColor,
              onPressed: () {
                setState(() => borderColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
            colorChangeTile(
              title: 'Change Board Color',
              alertTitle: 'Select Board Color',
              alertButtonText: 'Select',
              selectedColor: boardColor,
              onPressed: () {
                setState(() => boardColor = pickerColor);
                Navigator.of(context).pop();
              },
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

  Widget colorChangeTile({
    String title,
    String alertTitle,
    Color selectedColor,
    String alertButtonText,
    @required VoidCallback onPressed,
  }) {
    return ListTile(
      title: Text(title),
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 20,
          width: 20,
          color: selectedColor,
        ),
      ),
      onTap: () => showDialog(
        context: context,
        child: AlertDialog(
          title: Text(alertTitle),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: selectedColor,
              onColorChanged: changeColor,
              // showLabel: true, // only on portrait mode
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(alertButtonText),
              onPressed: onPressed,
              // () {
              //   setState(() => boardColor = pickerColor);
              //   Navigator.of(context).pop();
              // },
            ),
          ],
        ),
      ),
    );
  }
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
