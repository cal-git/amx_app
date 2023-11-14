import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';


var buttonColors = WindowButtonColors(
  iconNormal: Colors.black,
  mouseOver: const Color(0xFF00224b),
  mouseDown: Colors.black,
  iconMouseOver: Colors.white,
  iconMouseDown: Colors.white,
);

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(),
      ],
    );
  }
}