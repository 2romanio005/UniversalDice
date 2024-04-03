import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:universal_dice/Decoration/styles.dart';

import 'package:universal_dice/FutureBuilderHome.dart';

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: const FutureBuilderHome(),
      theme: mainTheme,
    );
  }
}
