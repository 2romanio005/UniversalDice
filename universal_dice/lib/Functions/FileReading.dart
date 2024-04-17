import 'dart:io';
import 'package:path/path.dart';

/// Получить число из названия файла или директории (всё название должно быть одним числом иначе null)
int? getNumberFromFileName(String path) {
  int start = path.lastIndexOf('/') + 1;
  int end = path.lastIndexOf('.');
  if (end <= start) {
    end = path.length;
  }
  return int.tryParse(path.substring(start, end));
}

/// Скопировать директорию со всем содержимым в новое место
Future<void> copyDirectory(String from, String to) async {
  if (from == to) {
    return;
  }
  print("from $from");
  print("to $to");

  await Directory(to).create(recursive: true);
  await for (final file in Directory(from).list(recursive: true)) {
    final copyTo = join(to, relative(file.path, from: from));
    //print("copyTo $copyTo");
    if (file is Directory) {
      await Directory(copyTo).create(recursive: true);
    } else if (file is File) {
      await File(file.path).copy(copyTo);
    }
  }
}
