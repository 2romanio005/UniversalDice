import 'package:universal_dice/Data/Dice.dart';

class DiceGroup {
  DiceGroup({required String name, required List<Dice> diceList}){
    _name = name;
    _diceList = diceList;
  }

  DiceGroup copy(){
    DiceGroup copy = DiceGroup(name: name, diceList: (_diceList.map((Dice dice) => dice.copy())).toList());
    return copy;
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

  void removeDiceAt(int index){
    _diceList.removeAt(index);
  }
  void pushDice(Dice dice){
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
