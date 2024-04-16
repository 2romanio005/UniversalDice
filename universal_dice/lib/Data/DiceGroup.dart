import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:universal_dice/Decoration/styles.dart';

import 'package:universal_dice/Functions/FileReading.dart';

import 'package:universal_dice/Data/Dice.dart';

const String _nameSettingsFile = "settings.txt";      // название файла с настройками группы

/// класс - группа кубиков, объединяет несколько кубиков одним именем, одной директорией, и позволяет проводить с ними глобальные операции
class DiceGroup {
    /// приватный конструктор группы
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

  /// конструктор читающий данные из памяти
  static Future<DiceGroup> creatingFromFiles(Directory directory) {
    DiceGroup resultDiceGroup = DiceGroup._(name: "", directory: directory);

    return Future.wait([
      resultDiceGroup._readSettings(),
      resultDiceGroup._readDiceList(),
    ]).then((_) => resultDiceGroup);
  }

  /// чтение настроек из файла
  Future<void> _readSettings() {
    File fileSettings = File("${_dirThisDiceGroup.path}/$_nameSettingsFile");

    return fileSettings.readAsString().then((str) {
      _name = str;
      //print("GroupName ${_dirThisDiceGroup.path} $str");
    }, onError: (err) {
      debugPrint(err);
    });
  }

  /// запись настроек в файл
  Future<void> _writeSettings() {
    return File("${_dirThisDiceGroup.path}/$_nameSettingsFile").writeAsString(_name);
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
            //print("Read dirDice: ${allDirDice[i].path} to $numberFromDirName");
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

  /// дублирование кубика и добавление его в конец списка
  Future<Dice> duplicateDice(int index) {
    String newPath = _getPathToDice();
    return Dice.copy(_diceList[index], newPath).then((dice) {
      _diceList.add(dice);
      return _diceList.last;
    });
  }

  /// добавление в конец списка стандартного кубика
  Future<Dice> addStandardDice() {
    return Directory(_getPathToDice()).create().then((dir) => Dice.creatingNewDice(dir).then((dice) {
          _diceList.add(dice);
          return _diceList.last;
        }));
  }

  /// полное удаление кубика из списка
  Future<bool> removeDiceAt([int? index]) {
    index ??= _diceList.length - 1;
    return _diceList[index].delete().then((_) {
      bool res = _diceList[index!].state;
      _diceList.removeAt(index);
      return res;
    });
  }

  /// полностью удаляет прошлый кубик и создаёт копию по образце вместо него.  должно быть []= но там нельзя возвращать future
  Future<void> replaceDiceAt (int index, Dice sampleDice) {
    return _diceList[index].delete().then(
          (_) => Dice.copy(sampleDice, _getPathToDice(index)).then(
            (newDice) => _diceList[index] = newDice,
      ),
    );
  }

  /// получить кубик
  Dice operator [](int index) {
    return _diceList[index];
  }

  /// получить путь до кубика по индексу .............................................. FIXME индекс может сместиться в большую сторону
  String _getPathToDice([int? index]) {
    return "${_dirThisDiceGroup.path}/${index ?? (_diceList.isEmpty ? "0" : (getNumberFromFileName(_diceList.last.directory.path)! + 1))}";
  }

  /// получить директорию этой группы  TODO поменять название
  Directory get directory {
    return _dirThisDiceGroup;
  }

  /// получить список всех выбранных кубиков
  List<Dice> get allSelectedDice {
    List<Dice> resultAllSelectedDice = List<Dice>.empty(growable: true);
    for (Dice dice in _diceList) {
      if (dice.state) {
        resultAllSelectedDice.add(dice);
      }
    }
    return resultAllSelectedDice;
  }

  /// получить количество кубиков
  int get length {
    return _diceList.length;
  }

  /// получить имя группы
  String get name {
    return _name;
  }

  /// построить простой виджет с именем
  Widget get nameWidget {
    return Text(
      name,
      textAlign: TextAlign.center,
      style: textTheme.titleMedium,
    );
  }

  /// установить новое имя с записью вв файл
  set name(String newName) {
    if (_name != newName) {
      _name = newName;
      _writeSettings();
    }
  }

  /// узнать состояние использования группы. Если хоть один выбран то группа считается тоже выбранной
  bool get state {
    for (Dice dice in _diceList) {
      if (dice.state == true) {
        return true;
      }
    }
    return false;
  }

  /// изменить состояние использования всех кубиков в группе
  set state(bool newState) {
    for (Dice dice in _diceList) {
      dice.state = newState;
    }
  }

  /// инвертировать состояние всей группы
  void invertState() {
    state = !state;
  }

  late List<Dice> _diceList;              // список всех кубиков
  late String _name;                      // имя группы
  final Directory _dirThisDiceGroup;      // директория этой группы
}
