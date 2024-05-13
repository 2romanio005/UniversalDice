import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_dice/Data/Dice.dart';

void main() async {
  Directory dirThisDice = Directory("path");
  dirThisDice = await Directory("${dirThisDice.path}/Test/0/0").create(recursive: true);

  File("image.jpg").create();

  Future<Dice> createDice() async {
    return Dice.creatingNewDice(dirThisDice);
  }

  Future<Dice> creatingModifiedDice() {
    return Dice.creatingNewDice(dirThisDice).then((testDice) {
      testDice.numberFaces = 5;
      testDice.state = true;
      return testDice.setFaceFile(1, File("image.jpg")).then((_) => testDice);
    });
  }

  void equalsDice(Dice actual, Dice expected){
    expect(actual.numberFaces, expected.numberFaces, reason: "разное numberFaces");
    expect(actual.state, expected.state, reason: "разные state");

    for(int i = 0; i < actual.numberFaces; i++){
      expect(actual.isFaceImage(i), expected.isFaceImage(i), reason:  "не совпало isFaceImage($i)");
    }
  }


  test("создания стандартного кубика creatingNewDice()", () async {
    Dice testDice = await createDice();

    expect(testDice.numberFaces, equals(6));
    expect(testDice.state, false);
    expect(testDice.dirThisDice, dirThisDice);
  });

  test("изменения количества граней numberFaces()", () async {
    Dice testDice = await createDice();
    testDice.numberFaces = 10;

    expect(testDice.numberFaces, equals(10));
    expect(testDice.lastRandFaceIndex, null);
  });

  test("изменения состояния invertState()", () async {
    Dice testDice = await createDice();

    testDice.state = true;
    expect(testDice.state, equals(true));
    testDice.invertState();
    expect(testDice.state, equals(false));
  });
  
  test("задать гране изображение setFaceFile()", () async {
    Dice testDice = await createDice();

    expect(testDice.isFaceImage(1), false);

    await testDice.setFaceFile(1, File("image.jpg"));
    expect(testDice.isFaceImage(1), true);

    await testDice.setFaceFile(1);
    expect(testDice.isFaceImage(1), false);
  });

  test("сгенерировать индекс случайной грани generateRandFaceIndex()", () async {
    Dice testDice = await createDice();
    testDice.numberFaces = 3;

    testDice.generateRandFaceIndex();

    expect(testDice.lastRandFaceIndex, greaterThanOrEqualTo(0));
    expect(testDice.lastRandFaceIndex, lessThan(testDice.numberFaces));

    testDice.resetLastRandFaceIndex();
    expect(testDice.lastRandFaceIndex, null);

    testDice.numberFaces = 1;
    testDice.generateRandFaceIndex();
    expect(testDice.lastRandFaceIndex, 0);

    testDice.numberFaces = 0;
    testDice.generateRandFaceIndex();
    expect(testDice.lastRandFaceIndex, -1);
  });

  test("создания кубика из файлов creatingFromFiles()", () async {
    Dice testDice = await creatingModifiedDice();

    Dice testDiceTwo = await Dice.creatingFromFiles(dirThisDice);

    equalsDice(testDiceTwo, testDice);
  });

  // test("копирование кубика copy()", () async {
  //   Dice testDice = await creatingModifiedDice();
  //
  //   Dice testDiceCopy = await Dice.copy(testDice, Directory("otherPath"));
  //
  //   equalsDice(testDiceCopy, testDice);
  //   expect(testDiceCopy.dirThisDice.path, "otherPath");
  // });

}