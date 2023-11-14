import 'package:amx_app/widgets/left_side_widget.dart';
import 'package:amx_app/widgets/right_side_widget.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            LeftSide(),
            RightSide(),
          ],
        ),
      ),
    );
  }
}