import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

import 'package:universal_dice/Functions/FileReading.dart';

import 'package:universal_dice/Decoration/styles.dart';

const String _nameSettingsFile = "settings.txt"; // название файла с настройками кубика

/// Класс - игральная кость (кубик), хранит все грани кубика и позволяет сгенерировать случайную из них при броске
class Dice {
  /// Приватный конструктор кубика
  Dice._(Directory dirThisDice) : _dirThisDice = dirThisDice {
    _state = false;
    _pathsToImages = List<File?>.empty(growable: true);

    //_pathsToImages = List<File?>.filled(numberFaces, nu
    // ll, growable: true);
  }

  /// Конструктор стандартного кубика
  static Future<Dice> creatingNewDice(Directory dirThisDice) {
    Dice resultDice = Dice._(dirThisDice);

    resultDice._pathsToImages.length = 6;
    return resultDice._writeSettings().then((_) => resultDice);
  }

  /// Конструктор читающий данные из памяти
  static Future<Dice> creatingFromFiles(Directory dirThisDice) {
    Dice resultDice = Dice._(dirThisDice);

    return Future.wait([
      resultDice._readSettings(),
      resultDice._readFaces(),
    ]).then((_) => resultDice);
  }

  /// Конструктор копирования
  static Future<Dice> copy(Dice sampleDice, String newPath) {
    return copyDirectory(sampleDice.dirThisDice.path, newPath).then((_) => Dice.creatingFromFiles(Directory(newPath)));
  }

  /// Удалить все файлы Dice
  Future<void> delete() {
    return dirThisDice.delete(recursive: true);
  }

  /// Чтение настроек из файла
  Future<void> _readSettings() {
    return File("${_dirThisDice.path}/$_nameSettingsFile").readAsLines().then((listSettings) {
      _pathsToImages.length = int.parse(listSettings[_AccordanceSettings.numberFaces.index]);
      _state = listSettings[_AccordanceSettings.state.index] == '1';
      //print("${_dirThisDice.path} DiceLength ${_pathsToImages.length} state $_state");
    }, onError: (err) {
      debugPrint("Ошибка чтения настроек кубика $err");
    });
  }

  /// Запись настроек в файл
  Future<void> _writeSettings() {
    List<String> data = List<String>.filled(_AccordanceSettings.length.index, "", growable: true);
    data[_AccordanceSettings.numberFaces.index] = numberFaces.toString();
    data[_AccordanceSettings.state.index] = _state ? '1' : '0';
    return File("${_dirThisDice.path}/$_nameSettingsFile").writeAsString(data.join('\n'));
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

  /// Проверить загружено ли изображение на эту грань
  bool isFaceImage(int index) {
    return _pathsToImages[index] != null;
  }

  /// Построить изображение грани, нужного размера, возможно с отступами
  Widget getFace({required double dimension, int? index, EdgeInsetsGeometry padding = EdgeInsets.zero}) {
    index ??= numberFaces - 1;
    return Container(
      padding: padding,
      //color: Colors.red,
      child: SizedBox.square(
        dimension: dimension,
        child: index != -1 && _pathsToImages[index] != null
            ? Image.file(
                _pathsToImages[index]!,
                width: dimension,
                height: dimension,
                frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: frame != null ? child : const CircularProgressIndicator(strokeWidth: 6),
                  );
                }),
              )
            : Container(
                padding: EdgeInsets.all(dimension / 20.0),
                color: colorsDiceFaceBackground[index % 6],
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    (index + 1).toString(),
                    textAlign: TextAlign.center,
                    style: textTheme.titleSmall?.merge(const TextStyle(
                      height: 1.0,
                      color: Colors.black,
                    )),
                  ),
                ),
              ),
      ),
    );
  }

  /// Установить фотографию грани
  Future<void> setFaceFile(int index, [File? sampleFile]) async {
    if (_pathsToImages[index] != null) {
      await _pathsToImages[index]!.delete();
    }

    if (sampleFile == null) {
      return Future(() => _pathsToImages[index] = null);
    } else {
      //FlutterImageCompress.compressAssetImage(sampleFile.path);
      // image.Image img = image.decodeImage(sampleFile.readAsBytesSync())!;
      // img = image.copyResize(img, width: 20);
      // File("${_dirThisDice.path}/$index.${sampleFile.path.split('.').last}").writeAsBytesSync(image.encodePng(img));
      return sampleFile.copy("${_dirThisDice.path}/$index.${sampleFile.path.split('.').last}").then((file) => _pathsToImages[index] = file);
    }
  }

  /// Получить директорию с этим кубиком          TODO Изменить название
  Directory get dirThisDice {
    return _dirThisDice;
  }

  /// Сгенерировать случайный индекс грани, которую будем отображать (и сохранить этот индекс до следующей генерации нового)
  void generateRandFaceIndex() {
    lastRandFaceIndex = numberFaces > 0 ? Random().nextInt(numberFaces) : -1;
  }

  /// Получить количество граней кубика
  int get numberFaces {
    return _pathsToImages.length;
  }

  /// Задать количество граней кубика
  set numberFaces(int newNumberFaces) {
    if (numberFaces != newNumberFaces) {
      for (int i = newNumberFaces; i < _pathsToImages.length; i++) {
        _pathsToImages[i]?.delete();
      }
      _pathsToImages.length = newNumberFaces;

      _writeSettings();
    }
  }

  /// Получить состояние использования
  bool get state {
    return _state;
  }

  /// Задать состояние использования
  set state(newState) {
    if (_state != newState) {
      _state = newState;
      _writeSettings();
    }
  }

  /// Инвертировать состояние использования кубика
  void invertState() {
    state = !state;
  }

  late List<File?> _pathsToImages; // список путей к изображениям
  late bool _state; // состояние использования кубика
  final Directory _dirThisDice; // директория этого кубика
  int? lastRandFaceIndex; // последнее сгенерированное
}

/// enum соотносящий данные в файле настроек с номером их строки
enum _AccordanceSettings {
  numberFaces,
  state,
  length,
}
