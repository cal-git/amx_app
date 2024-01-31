import 'package:amx_app/pages/home_page.dart';
import 'package:amx_app/pages/login_page.dart';
import 'package:amx_app/responsive/desktop_scaffold.dart';
import 'package:amx_app/responsive/mobile_scaffold.dart';
import 'package:amx_app/responsive/responsive_layout.dart';
import 'package:amx_app/responsive/tablet_scaffold.dart';

import 'package:amx_app/theme.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final win = appWindow;
    var minSize = const Size(500, 600);
    win.title = 'Inventario AMX';
    win.minSize = minSize;
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      title: 'Inventario Americanflex',
      theme: theme,
      //home: const LoginPage(),
      routes: {
        '/': (context) {
          doWhenWindowReady(() async {
            win.maximize();
            win.show();
          });
          return const LoginPage();
        },
        '/Home': (context) {
          doWhenWindowReady(() async {
            // Define o tamanho inicial como o tamanho da tela
            win.maximize();
            win.show();
          });
          return const ResponsiveLayout(
            mobileScaffold: MobileScaffold(),
            tabletScaffold: TabletScaffold(),
            desktopScaffold: DesktopScaffold(),
          );
        },
      },
    );
  }
}
