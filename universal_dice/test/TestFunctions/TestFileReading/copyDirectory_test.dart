import '../../DatabaseForTests.dart';

import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_dice/Functions/FileReading.dart';

void main() async {
  Database databaseFrom = await Database.create("from");
  await databaseFrom.clear();
  Database databaseTo = await Database.create("to");
  await databaseTo.clear();

  Future<void> fillDatabaseFrom() {
    return Database.create("from").then((databaseFrom) {
      return Directory("${databaseFrom.dir.path}/testDir").create(recursive: true).then((_) => File("${databaseFrom.dir.path}/testDirWithFile/testFile.txt").create(recursive: true));
    });
  }

  void equalsDir(List<FileSystemEntity> newDir, List<FileSystemEntity> oldDir) {
    next_one:
    for (final FileSystemEntity newFile in newDir) {
      for (final FileSystemEntity oldFile in oldDir) {
        if (basename(newFile.path) == basename(oldFile.path)) {
          continue next_one;
        }
      }
      expect(newFile.path, "какой-то другой но с таким же именем", reason: "Не найден оригинал файла ${newFile.path}");
    }

    next_two:
    for (final FileSystemEntity oldFile in oldDir) {
      for (final FileSystemEntity newFile in newDir) {
        if (basename(newFile.path) == basename(oldFile.path)) {
          continue next_two;
        }
      }
      expect(oldFile.path, "какой-то другой но с таким же именем", reason: "Не найдена копия файла ${oldFile.path}");
    }
  }

  test("Проверка что начальная директория не изменится при копирование не внутрь неё  ${databaseFrom.dir.path}->${databaseTo.dir.path}", () async {
    await fillDatabaseFrom();

    List<FileSystemEntity> oldDirFrom = databaseFrom.dir.listSync(recursive: true);

    await copyDirectory(databaseFrom.dir, databaseTo.dir);

    equalsDir(databaseFrom.dir.listSync(recursive: true), oldDirFrom);

    await databaseTo.clear();
    await databaseFrom.clear();
  });

  test("Обычное копирование директории ${basename(databaseFrom.dir.path)}->${basename(databaseTo.dir.path)}", () async {
    await fillDatabaseFrom();

    await copyDirectory(databaseFrom.dir, databaseTo.dir);

    equalsDir(databaseTo.dir.listSync(recursive: true), databaseFrom.dir.listSync(recursive: true));

    await databaseTo.clear();
    await databaseFrom.clear();
  });

  test("Копирование директории в неё же ${basename(databaseFrom.dir.path)}->${basename(databaseFrom.dir.path)}", () async {
    await fillDatabaseFrom();

    List<FileSystemEntity> oldDirFrom = databaseFrom.dir.listSync(recursive: true);

    await copyDirectory(databaseFrom.dir, databaseFrom.dir);

    equalsDir(databaseFrom.dir.listSync(recursive: true), oldDirFrom);
    await databaseFrom.clear();
  });
  
  test("Копирование директории в её поддиректорию ${basename(databaseFrom.dir.path)}->${basename(databaseFrom.dir.path)}/subDir", () async {
    await fillDatabaseFrom();

    List<FileSystemEntity> oldDirFrom = databaseFrom.dir.listSync(recursive: true);

    Directory subDir = Directory("${databaseFrom.dir.path}/subDir");

    await copyDirectory(databaseFrom.dir, subDir);

    equalsDir(subDir.listSync(recursive: true), oldDirFrom);
    await databaseFrom.clear();
  });
}
