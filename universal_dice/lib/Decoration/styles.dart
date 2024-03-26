import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

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

  /// осоновной текст
  bodyMedium: TextStyle(
    fontFamily: "Consolas",
    //color: ColorFont,
    fontSize: 18,
  ),

  /// заголовок всплывающих окон
  labelLarge: TextStyle(
    fontFamily: "Oswald",
    //color: ColorHeader,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  ),

  /// текс всплывающих окон
  labelMedium: TextStyle(
    fontFamily: "Consolas",
    //color: ColorFont,
    fontSize: 18,
  ),

  /// текст на кнопках
  labelSmall: TextStyle(
    fontFamily: "Consolas",
    //color: ColorFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
);

ThemeData mainTheme = ThemeData(
  colorScheme: colorScheme,
  textTheme: textTheme,
);


// цвета для кнопок
Color ColorButtonBackground = colorScheme.surface; // задний фон
Color ColorButtonForeground = colorScheme.onSurfaceVariant; // сама иконка или текс
const Color ColorButtonPressedOK = Color.fromARGB(255, 0, 180, 0); // при нажатии на кнопку "да"
const Color ColorButtonPressedOFF = Color.fromARGB(255, 220, 0, 0); // при нажатии на кнопку "нет"


/// кнопка несогласия (краснеет)
ButtonStyle buttonStyleOFF = IconButton.styleFrom(
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  backgroundColor: ColorButtonBackground,
  // hoverColor: ColorButtonHover,
  foregroundColor: ColorButtonForeground,
  highlightColor: ColorButtonPressedOFF,
);

/// кнопка согласия (зеленеет)
ButtonStyle buttonStyleOK = IconButton.styleFrom(
  backgroundColor: ColorButtonBackground,
  // hoverColor: ColorButtonHover,
  foregroundColor: ColorButtonForeground,
  highlightColor: ColorButtonPressedOK,
);

/// обычная кнопка (сереет)
ButtonStyle buttonStyleDefault = IconButton.styleFrom(
  backgroundColor: ColorButtonBackground,
  // hoverColor: ColorButtonHover,
  foregroundColor: ColorButtonForeground,
  highlightColor: colorScheme.surfaceVariant,
);
