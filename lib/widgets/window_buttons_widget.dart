import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

var buttonColors = WindowButtonColors(
  iconNormal: Colors.grey[400],
  iconMouseOver: Colors.white,
  iconMouseDown: const Color(0xFF00224b),
  mouseOver: const Color(0xFF00224b),
  mouseDown: const Color(0xFF00224b),
);

var buttonCloseColor = WindowButtonColors(
  iconNormal: Colors.grey[400],
  iconMouseOver: Colors.white,
  mouseOver: const Color(0xFF00224b),
  mouseDown: const Color(0xFF00224b),
);

class WindowButtons extends StatelessWidget {
  bool showMaximizeButton = true;
  WindowButtons({required this.showMaximizeButton, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        Visibility(
          visible: showMaximizeButton,
          child: MaximizeWindowButton(colors: buttonColors),
        ),
        CloseWindowButton(colors: buttonCloseColor),
      ],
    );
  }
}
