import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:universal_dice/Functions/FileReading.dart';

import 'package:universal_dice/Decoration/styles.dart';

const String nameSettingsFile = "settings.txt";

class Dice {
  Dice._(Directory directory) : _dirThisDice = directory {
    _state = false;
    _pathsToImages = List<File?>.empty(growable: true);
    //_pathsToImages = List<File?>.filled(numberFaces, null, growable: true);
  }

  /// конструктор стандартного кубика
  static Future<Dice> creatingStandard(Directory dirThisDice) {
    Dice resultDice = Dice._(dirThisDice);

    resultDice._pathsToImages.length = 6;
    return resultDice._writeSettings().then((_) => resultDice);
  }

  /// конструктор читающиц данные из памяти
  static Future<Dice> creatingFromFiles(Directory dirThisDice) {
    Dice resultDice = Dice._(dirThisDice);

    return Future.wait([
      resultDice._readSettings(),
      resultDice._readFaces(),
    ]).then((_) => resultDice);
  }

  /// чтение настроек из файла
  Future<void> _readSettings() {
    return File("${_dirThisDice.path}/$nameSettingsFile").readAsLines().then((listSettings) {
      _pathsToImages.length = int.parse(listSettings[_AccordanceSettings.numberFaces.index]);
      _state = listSettings[_AccordanceSettings.state.index] == '1';
      print("${_dirThisDice.path} DiceLenth ${_pathsToImages.length} state ${_state}");
    }, onError: (err) {
      print(err);
    });
  }

  /// запись настроек в файл
  Future<void> _writeSettings() {
    List<String> data = List<String>.filled(_AccordanceSettings.length.index, "", growable: true);
    data[_AccordanceSettings.numberFaces.index] = numberFaces.toString();
    data[_AccordanceSettings.state.index] = _state ? '1' : '0';
    return File("${_dirThisDice.path}/$nameSettingsFile").writeAsString(data.join('\n'));
  }

  /// Чтение всех граней
  Future<void> _readFaces() {
    return _dirThisDice.list(recursive: false).toList().then((entities) {
      final Iterable<File> allImageFiles = entities.whereType<File>();
      for (File imageFile in allImageFiles) {
        int? numberFromDirName = getNumberFromFileName(imageFile.path);
        if (numberFromDirName != null) {
          if (numberFromDirName >= _pathsToImages.length) {
            _pathsToImages.length = numberFromDirName + 1;
          }
          _pathsToImages[numberFromDirName] = imageFile;
        }
      }
    });
  }

  // Dice shallowCopy(){
  //   Dice shallowCopy = Dice(_pathsToImages.length);
  //   // не создавать копии фотографий
  //   return shallowCopy;
  // }

/*
  Future<Dice> copy(Directory dirNewDice) {
    File("${_dirThisDice.path}/$nameSettingsFile").copy("${dirNewDice.path}/$nameSettingsFile");
    for (File? file in _pathsToImages) {
      if (file != null) {
        file.copy("${dirNewDice.path}/${basename(file.path)}");
      }
    }

    return Dice.creatingFromFiles(dirNewDice);
  }
*/

  Directory get directory {
    return _dirThisDice;
  }

  Future<void> setFaceFile(int index, [File? sampleFile]) {
    if (sampleFile == null) {
      if (_pathsToImages[index] != null) {
        return _pathsToImages[index]!.delete().then((_) => _pathsToImages[index] = null);
      }
    } else {
      print("image from ${sampleFile.path}");
      print("image to ${_dirThisDice.path}/$index.${sampleFile.path.split('.').last}");
      return sampleFile.copy("${_dirThisDice.path}/$index.${sampleFile.path.split('.').last}").then((file) => _pathsToImages[index] = file);
    }
    return Future(() => null);
  }

  Widget getFace({required double dimension, int? index, EdgeInsetsGeometry padding = EdgeInsets.zero}) {
    index ??= numberFaces - 1;
    return Container(
      padding: padding,
      child: SizedBox.square(
          dimension: dimension,
          child: Container(
              padding: EdgeInsets.all(dimension / 20.0),
              color: Colors.white,
              child: index != -1 && _pathsToImages[index] != null
                  ? Image.file(_pathsToImages[index]!, width: dimension, height: dimension)
                  : FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        (index + 1).toString(),
                        textAlign: TextAlign.center,
                        style: textTheme.titleSmall?.merge(const TextStyle(
                          height: 1.0,
                          color: Colors.black,
                        )),
                      ),
                    ))),
    );
  }

  int get numberFaces {
    return _pathsToImages.length;
  }

  set numberFaces(int newNumberFaces) {
    if (numberFaces != newNumberFaces) {
      for (int i = newNumberFaces; i < _pathsToImages.length; i++) {
        _pathsToImages[i]?.delete();
      }
      _pathsToImages.length = newNumberFaces;

      _writeSettings();
    }
  }

  bool get state {
    return _state;
  }

  set state(newState) {
    if (_state != newState) {
      _state = newState;
      _writeSettings();
    }
  }

  void invertState() {
    state = !state;
  }

  late List<File?> _pathsToImages;
  late bool _state;
  final Directory _dirThisDice;
}

enum _AccordanceSettings {
  numberFaces,
  state,
  length,
}
