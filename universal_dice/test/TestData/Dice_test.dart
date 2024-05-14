import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_dice/Data/Dice.dart';

import '../DatabaseForTests.dart';
import 'equalsData.dart';

void main() async {
  final File image = File("${testDirGallery.path}/image_1.jpg");
  await image.create(recursive: true);

  Future<Dice> createDice(Database database) async {
    return Dice.creatingNewDice(database.dir);
  }

  Future<Dice> creatingModifiedDice(Database database) {
    return createDice(database).then((testDice) => testDice.setNumberFaces(5).then((_) => testDice.setState(true).then((_) => testDice.setFaceFile(1, image).then((_) => testDice))));
  }



  // TODO здесь нет тестов вызывающих ошибки

  test("Создания стандартного кубика creatingNewDice()", () async {
    Database database = await Database.createRand();
    Dice testDice = await createDice(database);

    expect(testDice.numberFaces, equals(6));
    expect(testDice.state, false);
    expect(testDice.dirThisDice, database.dir);

    database.clear();
  });

  test("Изменения количества граней numberFaces()", () async {
    Database database = await Database.createRand();
    Dice testDice = await createDice(database);
    await testDice.setNumberFaces(10);

    expect(testDice.numberFaces, equals(10));
    expect(testDice.lastRandFaceIndex, null);

    database.clear();
  });

  test("Изменения состояния invertState()", () async {
    Database database = await Database.createRand();
    Dice testDice = await createDice(database);

    await testDice.setState(true);
    expect(testDice.state, equals(true));
    await testDice.invertState();
    expect(testDice.state, equals(false));

    database.clear();
  });

  test("Задать гране изображение setFaceFile()", () async {
    Database database = await Database.createRand();
    Dice testDice = await createDice(database);

    expect(testDice.isFaceImage(1), false);

    await testDice.setFaceFile(1, image);
    expect(testDice.isFaceImage(1), true);

    await testDice.setFaceFile(1);
    expect(testDice.isFaceImage(1), false);

    database.clear();
  });

  test("Сгенерировать индекс случайной грани generateRandFaceIndex()", () async {
    Database database = await Database.createRand();
    Dice testDice = await createDice(database);
    await testDice.setNumberFaces(3);

    testDice.generateRandFaceIndex();

    expect(testDice.lastRandFaceIndex, greaterThanOrEqualTo(0));
    expect(testDice.lastRandFaceIndex, lessThan(testDice.numberFaces));

    testDice.resetLastRandFaceIndex();
    expect(testDice.lastRandFaceIndex, null);

    await testDice.setNumberFaces(1);
    testDice.generateRandFaceIndex();
    expect(testDice.lastRandFaceIndex, 0);

    await testDice.setNumberFaces(0);
    testDice.generateRandFaceIndex();
    expect(testDice.lastRandFaceIndex, -1);

    database.clear();
  });

  test("Создания кубика из файлов creatingFromFiles()", () async {
    Database database = await Database.createRand();
    Dice testDice = await creatingModifiedDice(database);

    Dice testDiceTwo = await Dice.creatingFromFiles(database.dir);

    equalsDice(testDiceTwo, testDice);

    database.clear();
  });

  test("Копирование кубика copy()", () async {
    Database database = await Database.createRand();
    Dice testDice = await creatingModifiedDice(database);

    Dice testDiceCopy = await Dice.copy(testDice, Directory("otherPath"));

    equalsDice(testDiceCopy, testDice);
    expect(testDiceCopy.dirThisDice.path, "otherPath");

    database.clear();
  });
}
