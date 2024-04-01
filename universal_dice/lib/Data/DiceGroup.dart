import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:universal_dice/Functions/FileReading.dart';

import 'package:universal_dice/Data/Dice.dart';

class DiceGroup {
  DiceGroup({required String name}) {
    _name = name;
    _diceList = [];
  }

  static Future<DiceGroup> readFromFiles(Directory dirDiceGroup) async {
    DiceGroup diceGroup = DiceGroup(name: "");

    File fileSettings = File("${dirDiceGroup.path}/settings.txt");
    fileSettings.readAsString().then(
      (str) {
        diceGroup._name = str;
      },
      onError: (err) {
        print(err);
      },
    );




    return diceGroup;
  }

  DiceGroup copy() {
    DiceGroup copy = DiceGroup(name: name);
    // , diceList: (_diceList.map((Dice dice) => dice.copy())).toList()
    /// TODO копирование
    return copy;
  }

  String get name {
    return _name;
  }

  Dice operator [](int index) {
    return _diceList[index];
  }

  int get length {
    return _diceList.length;
  }

  void removeDiceAt(int index) {
    _diceList.removeAt(index);
  }

  void addDice(Dice dice) {
    _diceList.add(dice);
  }

  bool get state {
    for (Dice dice in _diceList) {
      if (dice.state == true) {
        return true;
      }
    }
    return false;
  }

  set state(bool newState) {
    for (Dice dice in _diceList) {
      dice.state = newState;
    }
  }

  void invertState() {
    state = !state;
  }

  late String _name;
  late List<Dice> _diceList;
}
