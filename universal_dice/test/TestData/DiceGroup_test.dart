import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_dice/Data/Dice.dart';
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
    return createDiceGroup(database, 2).then((diceGroup) {
      return Future.forEach(List<Future<void> Function()>.generate(length, (index) => diceGroup.addStandardDice), (asyncFoo) => asyncFoo()).then((_) => diceGroup);
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

    await database.clear();
  });

  test("Изменение названия на нормальное setName()", () async {
    Database database = await createDatabase();
    DiceGroup diceGroup = await createDiceGroup(database, 0);

    await diceGroup.setName("Новое имя");

    expect(diceGroup.name, "Новое имя");

    await database.clear();
  });

  test("Изменение названия на пустое setName()", () async {
    Database database = await createDatabase();
    DiceGroup diceGroup = await createDiceGroup(database, 0);

    await diceGroup.setName("");

    expect(diceGroup.name, "");

    await database.clear();
  });

  test("Добавление стандартного кубика", () async {
    Database database = await createDatabase();
    DiceGroup diceGroup = await createDiceGroup(database, 0);

    expect(diceGroup.length, 0);
    await diceGroup.addStandardDice();

    expect(diceGroup.length, 1, reason: "Стандартный кубик не обавился так как length не измелилсь");

    await database.clear();
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

    await database.clear();
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

    await database.clear();
  });

  test("Удаление кубиков removeDiceAt()", () async {
    Database database = await createDatabase();
    int startNumber = 3;
    DiceGroup diceGroup = await createFillDiceGroup(database, startNumber);

    await diceGroup[1].setState(true);
    int numberFacesDeleted = 3;
    await diceGroup[1].setNumberFaces(numberFacesDeleted);
    bool res = await diceGroup.removeDiceAt(1);

    expect(diceGroup.length, startNumber - 1, reason: "количество кубиков не умельшилось");
    expect(res, true, reason: "Удалямый кубик остался");
    expect(diceGroup[1].numberFaces, 6, reason: "Удалямый кубик остался");

    await database.clear();
  });

  test("Создание групы из файлов creatingFromFiles()", () async {
    Database database = await createDatabase();
    int number = 3;
    DiceGroup diceGroupOrigin = await createModifiedDiceGroup(database, number);

    DiceGroup diceGroupNew = await DiceGroup.creatingFromFiles(diceGroupOrigin.dirThisDiceGroup);

    equalsDiceGroup(diceGroupNew, diceGroupOrigin);

    await database.clear();
  });

  test("Замена кубиков replaceDiceAt()", () async {
    Database database = await createDatabase();
    int startNumber = 3;
    DiceGroup diceGroup = await createFillDiceGroup(database, startNumber);

    Database databaseNewDice = await Database.createRand();
    Dice newDice = await Dice.creatingNewDice(databaseNewDice.dir);
    int numberFacesNew = 2;
    await newDice.setNumberFaces(numberFacesNew);

    int numberFacesReplaced = 3;
    await diceGroup[1].setNumberFaces(numberFacesReplaced);
    await diceGroup.replaceDiceAt(1, newDice);

    expect(diceGroup.length, startNumber, reason: "количество кубиков изменилось");
    expect(diceGroup[1].numberFaces, numberFacesNew, reason: "Заменяемый кубик не изменился");

    await database.clear();
    await databaseNewDice.clear();
  });

  test("Дублирование кубиков duplicateDice()", () async {
    Database database = await createDatabase();
    int number = 7;
    DiceGroup diceGroup = await createFillDiceGroup(database, number);

    int numberFacesDuplicate = 4;
    await diceGroup[1].setNumberFaces(numberFacesDuplicate);

    await diceGroup.duplicateDice(1);

    expect(diceGroup.length, number + 1, reason: "length не изменился");
    expect(diceGroup[diceGroup.length - 1].numberFaces, numberFacesDuplicate, reason: "кубик не такой же как дублируемый");
    await database.clear();
  });
}
