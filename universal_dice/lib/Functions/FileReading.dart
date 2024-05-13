import 'dart:io';
import 'package:path/path.dart';

/// Получить число из названия файла или директории (всё название должно быть одним числом иначе null)
int? getNumberFromFileSystemEntityName(FileSystemEntity entity) {
  basename(entity.path);
  int start = entity.path.lastIndexOf('/') + 1;
  int end = entity.path.lastIndexOf('.');
  if (end <= start) {
    end = entity.path.length;
  }
  return int.tryParse(entity.path.substring(start, end));
}

/// Скопировать директорию со всем содержимым в новое место
Future<void> copyDirectory(Directory from, Directory to) async {
  if (from == to) {
    return;
  }
  print("from ${from.path}");
  print("to ${to.path}");

  await to.create(recursive: true);
  await for (final file in from.list(recursive: true)) {
    final copyTo = join(to.path, relative(file.path, from: from.path));
    //print("copyTo $copyTo");
    if (file is Directory) {
      await Directory(copyTo).create(recursive: true);
    } else if (file is File) {
      await File(file.path).copy(copyTo);
    }
  }

  print("===================");
  await for (final file in to.list(recursive: true)) {
    print(file.path);
  }
  print("===================");
}
