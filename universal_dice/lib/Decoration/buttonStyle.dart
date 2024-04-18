import 'package:flutter/material.dart';

import 'package:universal_dice/Decoration/colors.dart';

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
