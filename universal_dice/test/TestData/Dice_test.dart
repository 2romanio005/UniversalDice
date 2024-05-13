import '../TestDatabase.dart';


import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_dice/Data/Dice.dart';

void main() async {
  final File image = File("${testDirGallery.path}/image_1.jpg");
  await image.create(recursive: true);

  Future<Dice> createDice(Database database) async {
    return Dice.creatingNewDice(database.dir);
  }

  Future<Dice> creatingModifiedDice(Database database) {
    return Dice.creatingNewDice(database.dir).then((testDice) => testDice.setNumberFaces(5).then((value) => testDice.setState(true).then((_) => testDice.setFaceFile(1, image).then((_) => testDice))));
  }

  void equalsDice(Dice actual, Dice expected) {
    expect(actual.numberFaces, expected.numberFaces, reason: "разное numberFaces");
    expect(actual.state, expected.state, reason: "разные state");

    for (int i = 0; i < actual.numberFaces; i++) {
      expect(actual.isFaceImage(i), expected.isFaceImage(i), reason: "не совпало isFaceImage($i)");
    }
  }

  test("создания стандартного кубика creatingNewDice()", () async {
    Database database = await Database.createRand();
    Dice testDice = await createDice(database);

    expect(testDice.numberFaces, equals(6));
    expect(testDice.state, false);
    expect(testDice.dirThisDice, database.dir);

    database.clear();
  });

  test("изменения количества граней numberFaces()", () async {
    Database database = await Database.createRand();
    Dice testDice = await createDice(database);
    await testDice.setNumberFaces(10);

    expect(testDice.numberFaces, equals(10));
    expect(testDice.lastRandFaceIndex, null);

    database.clear();
  });

  test("изменения состояния invertState()", () async {
    Database database = await Database.createRand();
    Dice testDice = await createDice(database);

    await testDice.setState(true);
    expect(testDice.state, equals(true));
    await testDice.invertState();
    expect(testDice.state, equals(false));

    database.clear();
  });

  test("задать гране изображение setFaceFile()", () async {
    Database database = await Database.createRand();
    Dice testDice = await createDice(database);

    expect(testDice.isFaceImage(1), false);

    await testDice.setFaceFile(1, image);
    expect(testDice.isFaceImage(1), true);

    await testDice.setFaceFile(1);
    expect(testDice.isFaceImage(1), false);

    database.clear();
  });

  test("сгенерировать индекс случайной грани generateRandFaceIndex()", () async {
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

  test("создания кубика из файлов creatingFromFiles()", () async {
    Database database = await Database.createRand();
    Dice testDice = await creatingModifiedDice(database);

    Dice testDiceTwo = await Dice.creatingFromFiles(database.dir);

    equalsDice(testDiceTwo, testDice);

    database.clear();
  });

  test("копирование кубика copy()", () async {
    Database database = await Database.createRand();
    Dice testDice = await creatingModifiedDice(database);

    Dice testDiceCopy = await Dice.copy(testDice, Directory("otherPath"));

    equalsDice(testDiceCopy, testDice);
    expect(testDiceCopy.dirThisDice.path, "otherPath");

    database.clear();
  });
}
