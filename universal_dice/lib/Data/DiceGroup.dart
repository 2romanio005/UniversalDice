import 'package:universal_dice/Data/Dice.dart';

class DiceGroup {
  DiceGroup({required String name, required List<Dice> diceList}){
    _name = name;
    _diceList = diceList;
  }

  String get name {
    return _name;
  }

  Dice operator [](int index){
    return _diceList[index];
  }

  int get length{
    return _diceList.length;
  }


  bool get state {
    for (Dice dice in _diceList) {
      if (dice.state == true) {
        return true;
      }
    }
    return false;
  }

  set state(newState) {
    for (Dice dice in _diceList) {
      dice.state = newState();
    }
  }

  void invertState() {
    state = !state;
  }

  late String _name;
  late List<Dice> _diceList;
}
