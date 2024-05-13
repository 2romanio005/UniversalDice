import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_dice/Functions/FileReading.dart';

void main() async {
  Directory dir = Directory("path/1/");
  File file = File("path/1.jpg");

  test ("получение числа их имени getNumberFromFileSystemEntityName на файле '${file.path}'", () async {
    expect(getNumberFromFileSystemEntityName(file), 1);
  });
  test ("получение числа из имени getNumberFromFileSystemEntityName на директории '${dir.path}'", () async {
    expect(getNumberFromFileSystemEntityName(dir), 1);
  });
}

