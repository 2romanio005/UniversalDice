import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_dice/Data/DiceGroupList.dart';

void main() async {
  //TestWidgetsFlutterBinding.ensureInitialized();

  // Directory dirDiceGroupList = Directory("path");
  // dirDiceGroupList = await Directory("${dirDiceGroupList.path}/Test").create(recursive: true);

  //test ("Проверка чтения всех групп из памяти когда их нет", () async {
    // DiceGroupList testDiceGroupList = await DiceGroupList.creatingFromFiles(dirDiceGroupList);
    // print("build");
    //
    // testDiceGroupList.addNewDiceGroup();
    // print("add new test");
    //
    // expect(testDiceGroupList[0].name, ("Стандартная группа"));
    //
    // expect(testDiceGroupList.length, equals(3));
    //
    // expect(testDiceGroupList[0][0].numberFaces, equals(2));
    // expect(testDiceGroupList[0][1].numberFaces, equals(6));
    // expect(testDiceGroupList[0][2 ].numberFaces, equals(10));
  //});
}