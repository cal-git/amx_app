import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

var sidebarColor = const Color(0xFFFFFFFF);

class LeftSide extends StatelessWidget {
  const LeftSide({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Container(
        color: sidebarColor,
        child: const Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xFFCBCCE8),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Olá, Carlos',
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
