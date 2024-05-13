import 'dart:io';
import 'package:path/path.dart';

/// Получить число из названия файла или директории (всё название должно быть одним числом иначе null)
int? getNumberFromFileSystemEntityName(FileSystemEntity entity) {
  String name = basename(entity.path);
  return int.tryParse(name.substring(0, name.lastIndexOf('.')));
}

/// Скопировать директорию со всем содержимым в новое место
/// TODO функция гадость я хз как её нормально писать
Future<void> copyDirectory(Directory from, Directory to) async {
  if (from == to) {
    return;
  }
  // print("===================");
  // print("from ${from.path}");
  // await for (final FileSystemEntity file in from.list(recursive: true)) {
  //   print("\t${file.path}");
  // }

  List<FileSystemEntity> filesList = await from.list(recursive: true).toList(); // приходится делать это до создания конечной директории т.к она может быть внутренней
  await to.create(recursive: true);

  for (final FileSystemEntity file in filesList) {
    final copyTo = join(to.path, relative(file.path, from: from.path));
    //print("copyTo $copyTo");
    if (file is Directory) {
      await Directory(copyTo).create(recursive: true);
    } else if (file is File) {
      await File(file.path).copy(copyTo);
    }
  }

  // print("to ${to.path}");
  // await for (final FileSystemEntity file in to.list(recursive: true)) {
  //   print("\t${file.path}");
  // }
  // print("===================");

}
