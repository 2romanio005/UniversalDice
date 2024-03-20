// все цвета объявляем сдесь, они ведь общие
// все названия начинаем со слова 'Color' и пишем за что он отвечает, чтобы не запутаться
import 'package:flutter/material.dart';

// Палитра основных цветов используются только внутри этого файла
// Создаём их копию с более понятным названием и использовать уже ёё
const Color ColorMain1 = Color.fromARGB(255, 47, 27, 126);
const Color ColorMain2 = Color.fromARGB(255, 236, 234, 255);
const Color ColorMain3 = Color.fromARGB(255, 220, 220, 220);
const Color ColorMain4 = Color.fromARGB(255, 0, 180, 0);
const Color ColorMain5 = Color.fromARGB(255, 220, 0, 0);
const Color ColorMain6 = Color.fromARGB(255, 0, 0, 0);
// все это надо когда начнём переделывать дизайн.

const Color ColorBackground = ColorMain2; // задний фон приложения
const Color ColorFont = ColorMain6; // шрифта
const Color ColorHeader = ColorMain1; // зоголовки
const Color ColorPrimary = ColorMain1; // основной текс для ColorScheme.fromSeed()

// цвета для кнопок
const Color ColorButtonBackground = ColorMain3; // задний фон
const Color ColorButtonHover = ColorMain2; // при наведении мыши
const Color ColorButtonForeground = ColorMain1; // сама иконка или текс
const Color ColorButtonPressedOK = ColorMain4; // при нажатии на кнопку "да"
const Color ColorButtonPressedOFF = ColorMain5; // при нажатии на кнопку "нет"
