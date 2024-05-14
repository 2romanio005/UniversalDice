import 'package:flutter_test/flutter_test.dart';

import 'package:universal_dice/Data/Dice.dart';
import 'package:universal_dice/Data/DiceGroup.dart';
import 'package:universal_dice/Data/DiceGroupList.dart';

bool equalsDice(Dice actual, Dice expected) {
  expect(actual.numberFaces, expected.numberFaces, reason: "разное numberFaces");
  expect(actual.state, expected.state, reason: "разные state");

  for (int i = 0; i < actual.numberFaces; i++) {
    if(actual.isFaceImage(i) == expected.isFaceImage(i)){
      expect(actual.isFaceImage(i), expected.isFaceImage(i), reason: "не совпало isFaceImage($i)");
      return false;
    }
  }
  return true;
}


bool equalsDiceGroup(DiceGroup actual, DiceGroup expected){
  expect(actual.length, expected.length, reason: "разное значение length");
  expect(actual.name, expected.name, reason: "разное значение name");

  for (int i = 0; i < actual.length; i++) {
    bool res = equalsDice(actual[i], expected[i]);
    if(res){
      expect(res, true, reason: "не совпал кубик номаре $i");
      return false;
    }
  }
  return true;
}
