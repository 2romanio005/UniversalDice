import 'dart:io';
import 'dart:math';

/// не забудь удалить директорию и поменять в .gitignore если меняешь эти переменные
final Directory testDirDevice = Directory("test/_DirForTesting/device");
final Directory testDirGallery = Directory("test/_DirForTesting/gallery");

class Database {
  Database._(String name) : dir = Directory("${testDirDevice.path}/$name");

  Future<void> clear() {
    return dir.delete(recursive: true);
  }

  static Future<Database> create(String name) {
    Database database = Database._(name);

    return database.dir.create(recursive: true).then((_) => database);
  }

  static Future<Database> createRand() {
    return Database.create("${Random().nextInt(200000000)}");
  }

  late Directory dir;
}
