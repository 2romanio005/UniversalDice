import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:universal_dice/Functions/FileReading.dart';

import 'package:universal_dice/Data/Dice.dart';
import 'package:universal_dice/Data/DiceGroup.dart';

/// Класс - список всех групп
class DiceGroupList {
  /// Приватный конструктор
  DiceGroupList._(Directory directory) : _dirThisDiceGroupList = directory {
    _diceGroupList = List<DiceGroup>.empty(growable: true);
  }

  /// Конструктор читающий данные из памяти
  static Future<DiceGroupList> creatingFromFiles() async {
    Directory dirThisDiceGroupList = await getApplicationDocumentsDirectory();
    dirThisDiceGroupList = await Directory("${dirThisDiceGroupList.path}/DiceGroups").create(recursive: true);

    DiceGroupList resultDiceGroupList = DiceGroupList._(dirThisDiceGroupList);
    return Future.wait([
      resultDiceGroupList._readDiceGroupList(),
    ]).then((_) => resultDiceGroupList);
  }

  /// Чтение всех групп
  Future<void> _readDiceGroupList() {
    final List<FileSystemEntity> entities = _dirThisDiceGroupList.listSync(recursive: false).toList();
    final List<Directory> allDirDiceGroup = entities.whereType<Directory>().toList();

    List<DiceGroup?> tmpDiceGroupList = List<DiceGroup?>.filled(allDirDiceGroup.length, null, growable: true);

    return Future.wait(Iterable<Future<void>>.generate(allDirDiceGroup.length, (i) {
      int? numberFromDirName = getNumberFromFileName(allDirDiceGroup[i].path);
      if (numberFromDirName != null) {
        return DiceGroup.creatingFromFiles(allDirDiceGroup[i]).then(
          (diceGroup) {
            if (numberFromDirName >= tmpDiceGroupList.length) {
              tmpDiceGroupList.length = numberFromDirName + 1;
            }
            tmpDiceGroupList[numberFromDirName] = diceGroup;
            // print("Read dirDiceGroup: ${allDirDiceGroup[i].path} to $numberFromDirName");
          },
        );
      }
      return Future(() => null);
    })).then((_) {
      for (DiceGroup? tmpDiceGroup in tmpDiceGroupList) {
        // копирование списка с убиранием null значений
        if (tmpDiceGroup != null) {
          // print("copy ${tmpDiceGroup.dirThisDiceGroup.path}");
          _diceGroupList.add(tmpDiceGroup);
        }
      }
      // print("all Read!");
    });
  }

  /// Дублирование группы и добавление её в конец списка
  Future<DiceGroup> duplicateDiceGroup(int index) {
    String newPath = _getPathToNewDiceGroup();
    return copyDirectory(_diceGroupList[index].dirThisDiceGroup.path, newPath).then((_) {
      return DiceGroup.creatingFromFiles(Directory(newPath)).then((diceGroup) {
        _diceGroupList.add(diceGroup);
        return diceGroup;
      });
    });
  }

  /// Добавление в конец списка пустой группы
  Future<DiceGroup> addNewDiceGroup() {
    return Directory(_getPathToNewDiceGroup()).create().then((dir) => DiceGroup.creatingNewDiceGroup(dir).then(
          (diceGroup) {
            _diceGroupList.add(diceGroup);
            return diceGroup;
          },
        ));
  }

  /// Полное удаление группы из списка
  Future<bool> removeDiceGroupAt([int? index]) {
    index ??= _diceGroupList.length - 1;
    return _diceGroupList[index].dirThisDiceGroup.delete(recursive: true).then((_) {
      bool res = _diceGroupList[index!].state;
      _diceGroupList.removeAt(index);
      return res;
    });
  }

  /// Получить путь до группы по индексу
  String _getPathToNewDiceGroup([int? index]) {
    return "${_dirThisDiceGroupList.path}/${_diceGroupList.isEmpty ? "0" : ((getNumberFromFileName(_diceGroupList[index ?? length - 1].dirThisDiceGroup.path) ?? -1) + 1)}";
  }

  /// Получить группу
  DiceGroup operator [](int index) {
    return _diceGroupList[index];
  }

  /// Получить список всех выбранных граней в формате удобном для вывода
  List<OneSelectedDiceGroup> get allSelectedDiceGroup {
    List<OneSelectedDiceGroup> resultAllSelectedDiceGroup = List<OneSelectedDiceGroup>.empty(growable: true);
    for (DiceGroup diceGroup in _diceGroupList) {
      List<Dice> allSelectedDice = diceGroup.allSelectedDice;
      if (allSelectedDice.isNotEmpty) {
        resultAllSelectedDiceGroup.add(OneSelectedDiceGroup(
          diceGroup: diceGroup,
          allDice: allSelectedDice,
        ));
      }
    }
    return resultAllSelectedDiceGroup;
  }

  /// Получить количество граней
  int get length {
    return _diceGroupList.length;
  }

  late List<DiceGroup> _diceGroupList; // список всех групп
  final Directory _dirThisDiceGroupList; // директория со всеми группами
}

/// Структура - необходимые для отображения данные использованной группы
class OneSelectedDiceGroup {
  OneSelectedDiceGroup({required this.diceGroup, required this.allDice});

  DiceGroup diceGroup;
  List<Dice> allDice;
}

late DiceGroupList diceGroupList; // список всех групп. Единственный и неповторимый
