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

ThemeData mainTheme = ThemeData(
  colorScheme: colorScheme,
  textTheme: textTheme,
);


// цвета для кнопок
Color colorButtonBackground = colorScheme.surface; // задний фон
//const colorButtonBackgroundDefault = Color.fromARGB(255, 23, 37, 16);
Color colorButtonForeground = colorScheme.onSurfaceVariant; // сама иконка или текс
const Color colorButtonBackgroundInverted = Color.fromARGB(255, 39, 59, 29);

const Color colorButtonPressedOK = Color.fromARGB(255, 0, 180, 0); // при нажатии на кнопку "да"
const Color colorButtonPressedOFF = Color.fromARGB(255, 220, 0, 0); // при нажатии на кнопку "нет"
Color colorButtonPressedDefault = colorScheme.surfaceVariant;


/// кнопка несогласия (краснеет)
ButtonStyle buttonStyleOFF = IconButton.styleFrom(
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  backgroundColor: colorButtonBackground,
  // hoverColor: colorButtonHover,
  foregroundColor: colorButtonForeground,
  highlightColor: colorButtonPressedOFF,
);

/// кнопка согласия (зеленеет)
ButtonStyle buttonStyleOK = IconButton.styleFrom(
  backgroundColor: colorButtonBackground,
  // hoverColor: colorButtonHover,
  foregroundColor: colorButtonForeground,
  highlightColor: colorButtonPressedOK,
);

/// обычная кнопка
ButtonStyle buttonStyleDefault = IconButton.styleFrom(
  backgroundColor: colorButtonBackground,
  // hoverColor: colorButtonHover,
  foregroundColor: colorButtonForeground,
  highlightColor: colorButtonPressedDefault,
);

/// обычная кнопка с другим задним фоном
ButtonStyle buttonStyleDefaultInverted = IconButton.styleFrom(
  backgroundColor: colorButtonBackgroundInverted,
  // hoverColor: colorButtonHover,
  foregroundColor: colorButtonForeground,
  highlightColor: colorButtonPressedDefault,
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