import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

var sidebarColor = Colors.white;

class LeftSide extends StatelessWidget {
  const LeftSide({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Container(
        color: sidebarColor,
        child: Column(
          children: [
            WindowTitleBarBox(
              child: MoveWindow(),
            ),
          ],
        ),
      ),
    );
  }
}
