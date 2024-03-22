import 'package:flutter/material.dart';
import 'dart:io';

import 'package:universal_dice/Decoration/styles.dart';

//import 'package:flutter/cupertino.dart';

class Dice {
  Dice(int numberFaces) {
    _pathsToImages = List<File?>.filled(numberFaces, null);
  }

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

  Widget getFace(double dimension, [int? index]) {
    index ??= numberFaces - 1;
    return SizedBox.square(
        dimension: dimension,
        child: Container(
            padding: EdgeInsets.all(dimension / 20.0),
            color: Colors.white,
            child: _pathsToImages[index] != null
                ? Image.file(_pathsToImages[0]!)
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
                  )));
  }

  late List<File?> _pathsToImages;

  bool _state = false;
}
