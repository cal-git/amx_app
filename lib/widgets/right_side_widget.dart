import 'package:amx_app/widgets/window_buttons_widget.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

var backgroundStartColor = const Color(0xFF667085);
var backgroundEndColor = const Color(0xFF344054);

class RightSide extends StatelessWidget {
  const RightSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F2EB),
        ),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
