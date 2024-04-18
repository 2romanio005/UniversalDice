import 'package:flutter/material.dart';

ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 0, 255, 0),
  brightness: Brightness.dark,
  // background: const Color.fromARGB(255, 17, 17, 17),
  // onSurface: Colors.red,

  // onPrimary: Colors.blue,
  onSurfaceVariant: const Color.fromARGB(255, 0, 255, 255),
  onSurface: const Color.fromARGB(255, 200, 235, 219),
  secondary: const Color.fromARGB(255, 84, 199, 149), //54, 181, 67),
  // surfaceTint :Colors.red,
  // onSurface: Colors.red,
  // surfaceVariant: Colors.yellow,
  // inverseSurface: Colors.pink,
);

/// цвета заднего фона у цифр на кубике по умолчанию
const colorsDiceFaceBackground = [
  Color.fromARGB(255, 255, 0, 0),
  Color.fromARGB(255, 0, 255, 0),
  Color.fromARGB(255, 0, 0, 255),
  Color.fromARGB(255, 255, 255, 0),
  Color.fromARGB(255, 255, 0, 255),
  Color.fromARGB(255, 0, 255, 255),
];
