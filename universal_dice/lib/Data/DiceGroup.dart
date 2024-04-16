import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:universal_dice/Decoration/styles.dart';

import 'package:universal_dice/Functions/FileReading.dart';

import 'package:universal_dice/Data/Dice.dart';

const String nameSettingsFile = "settings.txt";

class DiceGroup {
  DiceGroup._({required String name, required Directory directory}) : _dirThisDiceGroup = directory {
    _name = name;
    _diceList = List<Dice>.empty(growable: true);
  }

  /// конструктор стандартной группы
  static Future<DiceGroup> creatingNewDiceGroup(Directory dirThisDiceGroup) {
    DiceGroup resultDiceGroup = DiceGroup._(name: "Группа ${(getNumberFromFileName(dirThisDiceGroup.path) ?? 0) + 1}", directory: dirThisDiceGroup);
    //print("1 ${directory.path}");
    return resultDiceGroup._writeSettings().then((_) => resultDiceGroup);
  }

  /// конструктор читающиц данные из памяти
  static Future<DiceGroup> creatingFromFiles(Directory directory) {
    DiceGroup resultDiceGroup = DiceGroup._(name: "", directory: directory);

    return Future.wait([
      resultDiceGroup._readSettings(),
      resultDiceGroup._readDiceList(),
    ]).then((_) => resultDiceGroup);
  }

  /// чтение настроек из файла
  Future<void> _readSettings() {
    File fileSettings = File("${_dirThisDiceGroup.path}/$nameSettingsFile");

    return fileSettings.readAsString().then((str) {
      _name = str;
      print("GroupName ${_dirThisDiceGroup.path} $str");
    }, onError: (err) {
      print(err);
    });
  }

  /// запись настроек в файл
  Future<void> _writeSettings() {
    return File("${_dirThisDiceGroup.path}/$nameSettingsFile").writeAsString(_name);
  }

  /// чтение всех кубиков
  Future<void> _readDiceList() {
    final List<FileSystemEntity> entities = _dirThisDiceGroup.listSync(recursive: false).toList();
    final List<Directory> allDirDice = entities.whereType<Directory>().toList();

    List<Dice?> tmpDiceList = List<Dice?>.filled(allDirDice.length, null, growable: true);

    return Future.wait(Iterable<Future<void>>.generate(allDirDice.length, (i) {
      int? numberFromDirName = getNumberFromFileName(allDirDice[i].path);
      if (numberFromDirName != null) {
        return Dice.creatingFromFiles(allDirDice[i]).then(
          (dice) {
            if (numberFromDirName >= tmpDiceList.length) {
              tmpDiceList.length = numberFromDirName + 1;
            }
            tmpDiceList[numberFromDirName] = dice;
            print("Read dirDice: ${allDirDice[i].path} to $numberFromDirName");
          },
        );
      }
      return Future(() => null);
    })).then((_) {
      for (Dice? tmpDice in tmpDiceList) {
        // копирование списка с убиранием null значений
        if (tmpDice != null) {
          _diceList.add(tmpDice);
        }
      }
    });
  }

  Future<Dice> duplicateDice(int index) {
    String newPath = _getPathToDice();
    return Dice.copy(_diceList[index], newPath).then((dice) {
      _diceList.add(dice);
      return _diceList.last;
    });
  }

  Future<Dice> addStandardDice() {
    return Directory(_getPathToDice()).create().then((dir) => Dice.creatingNewDice(dir).then((dice) {
          _diceList.add(dice);
          return _diceList.last;
        }));
  }

  Future<bool> removeDiceAt([int? index]) {
    index ??= _diceList.length - 1;
    return _diceList[index].delete().then((_) {
      bool res = _diceList[index!].state;
      _diceList.removeAt(index);
      return res;
    });
  }

  String _getPathToDice([int? index]) {
    return "${_dirThisDiceGroup.path}/${index ?? (_diceList.isEmpty ? "0" : (getNumberFromFileName(_diceList.last.directory.path)! + 1))}";
  }

  Directory get directory {
    return _dirThisDiceGroup;
  }

  Dice operator [](int index) {
    return _diceList[index];
  }

  Future<void> replaceDiceAt (int index, Dice sampleDice) {
    return _diceList[index].delete().then(
          (_) {print("deleted orignal"); return Dice.copy(sampleDice, _getPathToDice(index)).then(
            (newDice) {print("Dice replaced"); return _diceList[index] = newDice;},
          );},
        );
  }

  List<Dice> get allSelectedDice {
    List<Dice> resultAllSelectedDice = List<Dice>.empty(growable: true);
    for (Dice dice in _diceList) {
      if (dice.state) {
        resultAllSelectedDice.add(dice);
      }
    }
    return resultAllSelectedDice;
  }

  int get length {
    return _diceList.length;
  }

  String get name {
    return _name;
  }

  Widget get nameWidget {
    return Text(
      name,
      textAlign: TextAlign.center,
      style: textTheme.titleMedium,
    );
  }

  set name(String newName) {
    if (_name != newName) {
      _name = newName;
      _writeSettings();
    }
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

  late List<Dice> _diceList;
  late String _name;
  final Directory _dirThisDiceGroup;
}
