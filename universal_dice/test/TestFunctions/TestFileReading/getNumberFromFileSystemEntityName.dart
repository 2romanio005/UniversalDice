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

  test ("Получение числа из имени на файле '${file.path}' getNumberFromFileSystemEntityName()", () async {
    expect(getNumberFromFileSystemEntityName(file), 1);
  });

  test ("Получение числа из имени на файле windows '${fileWindows.path}' getNumberFromFileSystemEntityName()", () async {
    expect(getNumberFromFileSystemEntityName(fileWindows), 1);
  });

  test ("Получение числа из имени на файле без цифры '${fileNull.path}' getNumberFromFileSystemEntityName()", () async {
    expect(getNumberFromFileSystemEntityName(fileNull), 1);
  });

  test ("Получение числа из имени на директории '${dir.path}' getNumberFromFileSystemEntityName()", () async {
    expect(getNumberFromFileSystemEntityName(dir), 1);
  });

  test ("Получение числа из имени на директории без цифры '${dirNull.path}' getNumberFromFileSystemEntityName()", () async {
    expect(getNumberFromFileSystemEntityName(dirNull), 1);
  });

  file.delete(recursive: true);
}

