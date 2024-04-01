import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:universal_dice/Functions/FileReading.dart';

import 'package:universal_dice/Data/Dice.dart';
import 'package:universal_dice/Data/DiceGroup.dart';

class DiceGroupList {
  DiceGroupList._() {
    _diceGroupList = [];
  }

  static Future<DiceGroupList> readFromFiles() async {
    DiceGroupList resultDiceGroupList = DiceGroupList._();

    Directory dirDiceGroups = await getApplicationDocumentsDirectory();
    dirDiceGroups = await Directory("${dirDiceGroups.path}/DiceGroups").create(recursive: true);

    final List<FileSystemEntity> entities = await dirDiceGroups.list(recursive: false).toList();
    final Iterable<Directory> allDirDiceGroup = entities.whereType<Directory>();

    resultDiceGroupList._diceGroupList.length = allDirDiceGroup.length;
    Future<void> readingFiles() async {
      for (Directory dirDiceGroup in allDirDiceGroup) {
        int? numberFromDirName = getNumberFromFileName(dirDiceGroup.path);
        if (numberFromDirName != null) {
          DiceGroup.readFromFiles(dirDiceGroup).then(
            (diceGroup) {
              resultDiceGroupList._diceGroupList[numberFromDirName!] = diceGroup;
              print("Read dirDiceGroup: ${dirDiceGroup.path} to $numberFromDirName");
            },
          );
        }
      }
    }

    await readingFiles(); // дождаться считывания всех файлов
    for(int i = resultDiceGroupList._diceGroupList.length - 1; i >= 0; i--){
      if(resultDiceGroupList._diceGroupList[i] == null){
        resultDiceGroupList._diceGroupList.removeAt(i);
        print("remove $i");
      }
    }
    print("all Read!");

    return resultDiceGroupList;
  }

  DiceGroup operator [](int index) {
    return _diceGroupList[index]!;
  }

  int get length {
    return _diceGroupList.length;
  }

  void removeDiceGroupAt(int index) {
    _diceGroupList.removeAt(index);
  }

  void addDiceGroup(DiceGroup diceGroup) {
    _diceGroupList.add(diceGroup);
  }

  late List<DiceGroup?> _diceGroupList;
}

late DiceGroupList diceGroupList; // = DiceGroupList();
