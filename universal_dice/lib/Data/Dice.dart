import 'package:flutter/material.dart';
import 'dart:io';

import 'package:universal_dice/Decoration/styles.dart';

//import 'package:flutter/cupertino.dart';

class Dice {
  Dice(int numberFaces) {
    _pathsToImages = List<File?>.filled(numberFaces, null, growable: true);
  }

  // Dice shallowCopy(){
  //   Dice shallowCopy = Dice(_pathsToImages.length);
  //   // не создавать копии фотографий
  //   return shallowCopy;
  // }

  Dice copy() {
    Dice copy = Dice(_pathsToImages.length);
    return copy;
  }

  bool get state {
    return _state;
  }

  set state(newState) {
    _state = newState;
  }

  void invertState() {
    _state = !_state;
  }

  int get numberFaces {
    return _pathsToImages.length;
  }

  set numberFaces(int newNumberFaces) {
    _pathsToImages.length = newNumberFaces;
  }

  Future<void> setFaceFile(int index, File? file) async {
    /// FIXE удалять предудущий файл, и копировать этот на его место
    _pathsToImages[index] = file;
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
              child: _pathsToImages[index] != null
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



  late List<File?> _pathsToImages;

  bool _state = false;
}
