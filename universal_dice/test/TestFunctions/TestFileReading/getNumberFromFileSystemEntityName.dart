import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_dice/Functions/FileReading.dart';

void main() async {
  Directory dir = Directory("path/1/");
  Directory dirNull = Directory("path/abc");
  File file = File("path/1.jpg");
  File fileWindows = File("path\\1.jpg");
  File fileNull = File("path/abc.jpg");

  test ("получение числа их имени getNumberFromFileSystemEntityName на файле '${file.path}'", () async {
    expect(getNumberFromFileSystemEntityName(file), 1);
  });

  test ("получение числа их имени getNumberFromFileSystemEntityName на файле windows '${fileWindows.path}'", () async {
    expect(getNumberFromFileSystemEntityName(fileWindows), 1);
  });

  test ("получение числа их имени getNumberFromFileSystemEntityName на файле без цифры '${fileNull.path}'", () async {
    expect(getNumberFromFileSystemEntityName(fileNull), 1);
  });

  test ("получение числа из имени getNumberFromFileSystemEntityName на директории '${dir.path}'", () async {
    expect(getNumberFromFileSystemEntityName(dir), 1);
  });

  test ("получение числа из имени getNumberFromFileSystemEntityName на директории без цифры '${dirNull.path}'", () async {
    expect(getNumberFromFileSystemEntityName(dirNull), 1);
  });

  file.delete(recursive: true);
}

