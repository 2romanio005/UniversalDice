import 'dart:io';
import 'dart:math';

final Directory testDirDevice = Directory("TestDir/device");
final Directory testDirGallery = Directory("TestDir/gallery");

class Database{
  Database._(String name) : dir = Directory("${testDirDevice.path}/$name");

  void clear() async {
    dir.delete(recursive: true);
  }

  static Future<Database> create(String name){
    Database database =  Database._(name);

    return database.dir.create(recursive: true).then((_) => database);
  }

  static Future<Database> createRand(){
    return Database.create("${Random().nextInt(200000000)}");
  }

  
  late Directory dir;
}