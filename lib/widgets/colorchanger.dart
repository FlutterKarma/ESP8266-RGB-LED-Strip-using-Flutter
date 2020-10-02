import 'package:flutter/material.dart';
import 'package:neopixelcontroler/utility/utilitys.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class ColorChanger extends StatefulWidget {
  final String selectedDevice;
  final Color color;
  ColorChanger({this.color, this.selectedDevice});

  @override
  _ColorChangerState createState() => _ColorChangerState();
}

class _ColorChangerState extends State<ColorChanger> {
  Color currentColor = Colors.white;
  bool firstUserInteraction;

  @override
  void initState() {
    firstUserInteraction = false;
    super.initState();
  }

  Future<void> getLastColor() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("lastColor${widget.selectedDevice}")) {
      int lastColor = prefs.getInt("lastColor${widget.selectedDevice}");
      setState(() {
        currentColor = Color(lastColor);
      });
    }
  }

  Icon getColorIcon() {
    if (!firstUserInteraction || firstUserInteraction == null) {
      getLastColor();
    }
    return Icon(Icons.bubble_chart, color: currentColor);
  }

  void setLastColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("lastColor${widget.selectedDevice}", color.value);
  }

  void changecolor(Color color) {
    setState(() => currentColor = color);
    // performance-issues
    // setColor(color);
  }

  @override
  Widget build(BuildContext context) {
    // Shuold use a FutureBuilder
    return CircleColorPicker(
      initialColor: currentColor,
      onChanged: _onColorChanged,
      colorCodeBuilder: (context, color) {
        return Text(
          'rgb(${color.red}, ${color.green}, ${color.blue})',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      },
    );
  }

  void _onColorChanged(Color color) {
    setState(() => currentColor = color);
    setColor(currentColor, context, widget.selectedDevice);
  }
}
