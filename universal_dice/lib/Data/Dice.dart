//import 'dart:math';


//import 'package:flutter/cupertino.dart';

class Dice{
  Dice(int numberFaces){
     _pathsToImages.length = numberFaces;
  }

  bool get state{
    return _state;
  }
  set state(newState) {
    _state = newState;
  }
  void invertState(){
    _state = !_state;
  }

  int get numberFaces{
    return _pathsToImages.length;
  }


  late List<String> _pathsToImages;

  bool _state = false;
}

