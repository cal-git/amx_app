import 'package:amx_app/widgets/window_buttons_widget.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

var myDefaultBackground = Colors.grey[100];

var myWindowTitleBarBox = Column(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 40,
        color: const Color(0xFF00224b),
        child: WindowTitleBarBox(
          child: Row(
            children: [
              Expanded(
                child: MoveWindow(),
              ),
              WindowButtons(
                showMaximizeButton: false,
              ),
            ],
          ),
        ),
      ),
    ),
  ],
);

var myAppBar = AppBar(
  backgroundColor: const Color(0xFF00224b),
  iconTheme: const IconThemeData(color: Colors.white),
);

var myDrawer = Drawer(
  backgroundColor: myDefaultBackground,
  child: Builder(
    builder: (context) => buildDrawer(context),
  ),
);

Widget buildDrawer(BuildContext context) {
  return Column(
    children: [
      DrawerHeader(
        child: CircleAvatar(
          backgroundColor: Colors.grey[100],
          radius: 60,
          child: Icon(
            Icons.add_a_photo_rounded,
            size: 80,
            color: Colors.grey[200],
          ),
        ),
      ),
      const ListTile(
        leading: Icon(Icons.home_outlined),
        title: Text('H O M E'),
      ),
      const ListTile(
        leading: Icon(Icons.inventory_2_outlined),
        title: Text('I N V E N T A R I O'),
      ),
      const ListTile(
        leading: Icon(Icons.settings_outlined),
        title: Text('C O N F I G U R A Ç Õ E S'),
      ),
      const Spacer(),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('S A I R'),
        onTap: () => Navigator.pushReplacementNamed(context, '/'),
      ),
    ],
  );
}
