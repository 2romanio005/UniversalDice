import 'package:flutter/material.dart';

import 'package:universal_dice/Decoration/colors.dart';

TextTheme textTheme = TextTheme(

  /// H1
  titleLarge: TextStyle(
    fontFamily: "Oswald",
    //color: ColorHeader,
    color: colorScheme.primary,
    fontSize: 26,
    fontWeight: FontWeight.bold,
  ),

  /// H2
  titleMedium: TextStyle(
    fontFamily: "Oswald",
    //color: ColorFont,
    color: colorScheme.secondary,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  ),

  /// H3
  titleSmall: TextStyle(
    fontFamily: "Oswald",
    color: colorScheme.onSurface,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),

  /// основной текст
  bodyMedium: const TextStyle(
    fontFamily: "Consolas",
    //color: ColorFont,
    fontSize: 18,
  ),

  /// заголовок всплывающих окон
  labelLarge: const TextStyle(
    fontFamily: "Oswald",
    //color: ColorHeader,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  ),

  /// текс всплывающих окон
  labelMedium: const TextStyle(
    fontFamily: "Consolas",
    //color: ColorFont,
    fontSize: 18,
  ),

  /// текст на кнопках
  labelSmall: const TextStyle(
    fontFamily: "Consolas",
    //color: ColorFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
);
