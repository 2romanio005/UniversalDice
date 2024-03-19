import 'package:flutter/material.dart';
import 'package:universal_dice/FutureBuilderHome.dart';

import 'package:universal_dice/Decoration/styles.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const FutureBuilderHome(),
      theme: mainTheme,
    );
  }
}
