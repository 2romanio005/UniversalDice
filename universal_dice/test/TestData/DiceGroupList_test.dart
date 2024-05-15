import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_dice/Data/DiceGroupList.dart';

import '../DatabaseForTests.dart';
import 'equalsData.dart';

void main() async {
  test("Создание списка групп из пустой папки DiceGroupList.creatingFromFiles()", () async {
    Database database = await Database.createRand();
    DiceGroupList testDiceGroupList = await DiceGroupList.creatingFromFiles(database.dir);

    expect(testDiceGroupList.length, 1, reason: " length не измелился. Возможно стартовые кубики не были созданы");
    expect(testDiceGroupList[0].name, "Стандартная группа", reason: "не правильное название стандартной группы");

    expect(testDiceGroupList[0].length, 3, reason: "в стандартной группе не 3 кубика  ");
    expect(testDiceGroupList[0][0].numberFaces, 2, reason: "у первого кубика не 2 грани");
    expect(testDiceGroupList[0][1].numberFaces, 6, reason: "у первого кубика не 6 граней");
    expect(testDiceGroupList[0][2].numberFaces, 10, reason: "у первого кубика не 10 граней");

    await database.clear();
  });

  test("Удаление группы DiceGroupList.removeDiceGroupAt()", () async {
    Database database = await Database.createRand();
    DiceGroupList testDiceGroupList = await DiceGroupList.creatingFromFiles(database.dir);

    int numberTest = 0;
    Future<void> removeDiceGroup(int index, int expectedLength) async {
      Directory oldDir = testDiceGroupList[index].dirThisDiceGroup;
      await testDiceGroupList.removeDiceGroupAt(index);
      expect(testDiceGroupList.length, expectedLength, reason: "length не изменился. Возможно не была удалена группа в подтесте номер $numberTest");
      expect(oldDir.existsSync(), false, reason: "Директория с группой всё ещё существует. Возможно она не была удалена в подтесте номер $numberTest");
      numberTest++;
    }

    await removeDiceGroup(0, 0);

    await testDiceGroupList.addNewDiceGroup();
    await testDiceGroupList.addNewDiceGroup();
    await testDiceGroupList.addNewDiceGroup();
    await testDiceGroupList.addNewDiceGroup();
    await removeDiceGroup(1, 3);
    await removeDiceGroup(2, 2);
    await removeDiceGroup(1, 1);

    await database.clear();
  });

  test("Добавление новой группы DiceGroupList.addNewDiceGroup()", () async {
    Database database = await Database.createRand();
    DiceGroupList testDiceGroupList = await DiceGroupList.creatingFromFiles(database.dir);

    int numberTest = 0;
    Future<void> addDiceGroup(int expectedLength, int expectedDirNumber) async {
      await testDiceGroupList.addNewDiceGroup();
      expect(testDiceGroupList.length, expectedLength, reason: "length не изменился. Возможно не была создана новая группа в подтесте номер $numberTest");
      expect(testDiceGroupList[testDiceGroupList.length - 1].dirThisDiceGroup.path, "${database.dir.path}/$expectedDirNumber",
          reason: "Была создана не та директорию, которую я предсказал в подтесте номер $numberTest");
      numberTest++;
    }

    await addDiceGroup(2, 1);
    await addDiceGroup(3, 2);

    await testDiceGroupList.removeDiceGroupAt(1);
    await addDiceGroup(3, 3);

    await testDiceGroupList.removeDiceGroupAt(1);
    await testDiceGroupList.removeDiceGroupAt(1);
    await addDiceGroup(2, 1);

    await testDiceGroupList.removeDiceGroupAt(0);
    await testDiceGroupList.removeDiceGroupAt(0);
    await addDiceGroup(1, 0);

    await database.clear();
  });

  test("Удаление группы не указав индекс DiceGroupList.removeDiceGroupAt(null)", () async {
    Database database = await Database.createRand();
    DiceGroupList testDiceGroupList = await DiceGroupList.creatingFromFiles(database.dir);

    await testDiceGroupList.addNewDiceGroup();

    Directory oldDir = testDiceGroupList[testDiceGroupList.length - 1].dirThisDiceGroup;
    await testDiceGroupList.removeDiceGroupAt();
    expect(testDiceGroupList.length, 1, reason: "length не изменился. Возможно не была удалена группа 1");
    expect(oldDir.existsSync(), false, reason: "Директория с группой всё ещё существует. Возможно она не была удалена 1");

    oldDir = testDiceGroupList[testDiceGroupList.length - 1].dirThisDiceGroup;
    await testDiceGroupList.removeDiceGroupAt();
    expect(testDiceGroupList.length, 0, reason: "length не изменился. Возможно не была удалена группа 2");
    expect(oldDir.existsSync(), false, reason: "Директория с группой всё ещё существует. Возможно она не была удалена 2");

    await database.clear();
  });

  test("Дублирование группы DiceGroupList.duplicateDiceGroup()", () async {
    Database database = await Database.createRand();
    DiceGroupList testDiceGroupList = await DiceGroupList.creatingFromFiles(database.dir);

    await testDiceGroupList.addNewDiceGroup();
    await testDiceGroupList.duplicateDiceGroup(0);

    equalsDiceGroup(testDiceGroupList[2], testDiceGroupList[0]);

    await testDiceGroupList.removeDiceGroupAt(0);
    await testDiceGroupList.removeDiceGroupAt(0);
    await testDiceGroupList.duplicateDiceGroup(0);

    equalsDiceGroup(testDiceGroupList[1], testDiceGroupList[0]);

    await database.clear();
  });

  test("Получить список всех активных группы кубиков get DiceGroup.allSelectedDice", () async {
    Database database = await Database.createRand();
    DiceGroupList testDiceGroupList = await DiceGroupList.creatingFromFiles(database.dir);
    for (int i = 0; i < 3; i++) {
      await testDiceGroupList.duplicateDiceGroup(0);
    }

    int numberTes = 0;
    Future<void> checkSelectedDiceGroup(List<int> list) async {
      for (int i = 0; i < testDiceGroupList.length; i++) {
        await testDiceGroupList[i].setState(false);
      }

      for (int index in list) {
        await testDiceGroupList[index][1].setState(true);
      }
      List<SelectedDiceGroup> selectedDiceGroup = testDiceGroupList.allSelectedDiceGroup;

      expect(selectedDiceGroup.length, list.length, reason: "length не совпадают. Возможно были выбраны не все активные группы кубики в подтесте номер $numberTes");

      int i = 0;
      for (int index in list) {
        expect(selectedDiceGroup[i].diceGroup.dirThisDiceGroup.path, testDiceGroupList[index].dirThisDiceGroup.path,
            reason: "Выбранны группы, которые не были активными. Не был активным группа норме $index в подтесте номер $numberTes");
        expect(selectedDiceGroup[i].allDice.length, 1, reason: "В выбранной группе оказалсь не столько же выбранных кубиков сколько активных");
        i++;
      }
      numberTes++;
    }

    await checkSelectedDiceGroup([0, 1, 3]);
    await checkSelectedDiceGroup([1, 2]);

    database.clear();
  });
}
