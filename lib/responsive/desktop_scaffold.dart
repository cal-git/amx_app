import 'package:amx_app/pages/home_page.dart';
import 'package:amx_app/responsive/constants.dart';
import 'package:flutter/material.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myDefaultBackground,
      body: Column(
        children: [
          myWindowTitleBarBox,
          const Padding(
            padding: EdgeInsets.all(50),
            child: HomePage(),
          ),
        ],
      ),
    );
  }
}
