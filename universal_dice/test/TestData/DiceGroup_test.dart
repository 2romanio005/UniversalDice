import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_dice/Data/DiceGroup.dart';

import '../DatabaseForTests.dart';
import 'equalsData.dart';

void main() async {
  Future<Database> createDatabase() {
    return Database.createRand();
  }

  Future<Directory> createDiceDirByNumber(Database database, int number) {
    return Directory("${database.dir.path}/$number").create(recursive: true);
  }

  Future<DiceGroup> createDiceGroup(Database database, int number) async {
    Directory diceDir = await createDiceDirByNumber(database, number);

    return DiceGroup.creatingNewDiceGroup(diceDir);
  }

  Future<DiceGroup> createFillDiceGroup(Database database, int length) {
    return createDiceGroup(database, 2).then((diceGroup) async {
      for(int i = 0; i < length; i++){
        await diceGroup.addStandardDice();
      }
      return diceGroup;
    });
  }

  Future<DiceGroup> createModifiedDiceGroup(Database database, int length) {
    expect(length, greaterThan(2), reason: "ошибка при createModifiedDiceGroup() слишком маленькая длина");
    return createFillDiceGroup(database, length).then((diceGroup) => diceGroup.removeDiceAt(0).then((_) => diceGroup.addStandardDice().then((_) => diceGroup)));
  }

  test("Создание стандартной группы creatingNewDiceGroup()", () async {
    Database database = await createDatabase();
    DiceGroup diceGroup = await createDiceGroup(database, 0);

    expect(diceGroup.length, 0);
    expect(diceGroup.name, "Группа 1");
    Directory diceDir = await createDiceDirByNumber(database, 0);
    expect(diceGroup.dirThisDiceGroup.path, equals(diceDir.path));

    database.clear();
  });

  test("Изменение названия на нормальное setName()", () async {
    Database database = await createDatabase();
    DiceGroup diceGroup = await createDiceGroup(database, 0);

    await diceGroup.setName("Новое имя");

    expect(diceGroup.name, "Новое имя");

    database.clear();
  });

  test("Изменение названия на пустое setName()", () async {
    Database database = await createDatabase();
    DiceGroup diceGroup = await createDiceGroup(database, 0);

    await diceGroup.setName("");

    expect(diceGroup.name, "");

    database.clear();
  });

  test("Изменение состояния invertState()", () async {
    Database database = await createDatabase();
    int number = 3;
    DiceGroup diceGroup = await createFillDiceGroup(database, number);

    expect(diceGroup.length, number);
    for (int i = 0; i < number; i++) {
      expect(diceGroup[i].state, false, reason: "несовпажает state у кубика номер $i перед изменением}");
    }

    await diceGroup.invertState();

    for (int i = 0; i < number; i++) {
      expect(diceGroup[i].state, true, reason: "несовпажает state у кубика номер $i после изменения}");
    }

    database.clear();
  });

  test("Изменение состояния setState()", () async {
    Database database = await createDatabase();

    int number = 3;
    DiceGroup diceGroup = await createFillDiceGroup(database, number);

    expect(diceGroup.length, number);
    for (int i = 0; i < number; i++) {
      expect(diceGroup[i].state, false, reason: "несовпажает state у кубика номер $i перед изменением}");
    }

    await diceGroup.setState(true);

    for (int i = 0; i < number; i++) {
      expect(diceGroup[i].state, true, reason: "несовпажает state у кубика номер $i после изменения}");
    }

    await diceGroup.setState(true);

    for (int i = 0; i < number; i++) {
      expect(diceGroup[i].state, true, reason: "несовпажает state у кубика номер $i после второго изменения}");
    }

    database.clear();
  });

  test("Создание групы из файлов creatingFromFiles()", () async {
    Database database = await createDatabase();
    int number = 3;
    DiceGroup diceGroupOrigin = await createModifiedDiceGroup(database, number);

    DiceGroup diceGroupNew = await DiceGroup.creatingFromFiles(diceGroupOrigin.dirThisDiceGroup);

    equalsDiceGroup(diceGroupNew, diceGroupOrigin);

    database.clear();
  });
}
