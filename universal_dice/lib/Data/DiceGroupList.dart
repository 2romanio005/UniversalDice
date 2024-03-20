import 'package:universal_dice/Data/DiceGroup.dart';

import 'package:universal_dice/Data/Dice.dart';
import 'package:universal_dice/Data/DiceGroup.dart';

class DiceGroupList {
  DiceGroup operator [](int index) {
    return _diceGroupList[index];
  }

  int get length {
    return _diceGroupList.length;
  }

  void removeDiceGroupAt(int index){
    _diceGroupList.removeAt(index);
  }

  void addDiceGroup(DiceGroup diceGroup){
    _diceGroupList.add(diceGroup);
  }

  List<DiceGroup> _diceGroupList = [
    DiceGroup(name: "Standart", diceList: [Dice(6), Dice(10), Dice(18)]),
    DiceGroup(name: "Second", diceList: [Dice(6)]),
  ];
}

DiceGroupList diceGroupList = DiceGroupList();
