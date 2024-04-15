import 'package:flutter/material.dart';

import 'package:universal_dice/Decoration/styles.dart';

import 'package:universal_dice/Data/Dice.dart';
import 'package:universal_dice/Data/DiceGroupList.dart';

class HomePageView extends StatefulWidget {
  HomePageView({super.key, required this.allSelectedDiceGroup}) {
    for (OneSelectedDiceGroup selectedDiceGroup in allSelectedDiceGroup) {
      for (Dice dice in selectedDiceGroup.allDice) {
        dice.lastRandFaceIndex = null;
      }
    }
  }

  @override
  State<StatefulWidget> createState() => _HomePageView();

  List<OneSelectedDiceGroup> allSelectedDiceGroup;
}

class _HomePageView extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    const double padding = 20;
    return widget.allSelectedDiceGroup.isEmpty
        ?
    const Padding(
      padding: EdgeInsets.fromLTRB(padding, 100, padding, 0),
      child: Text(
        "Выберите какие кубики кидать, нажав на кнопку в верхнем (правом или левом) углу.",
        textAlign: TextAlign.center,
      ),
    ) :
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Expanded(child: _buildSelectedDiceGroupList()),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 12),
              child: TextButton(
                style: buttonStyleDefaultInverted,
                onPressed: () {
                  for (OneSelectedDiceGroup selectedDiceGroup in widget.allSelectedDiceGroup){
                    for (Dice dice in selectedDiceGroup.allDice){
                      dice.generateRandFaceIndex();
                    }
                  }
                  setState(() {});
                },
                child: const FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text("Бросить все игральные кости"),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedDiceGroupList() {
    return SingleChildScrollView(
      child: Column(
        children: List<Widget>.generate(
          widget.allSelectedDiceGroup.length,
          (index) => _buildSelectedDiceGroup(widget.allSelectedDiceGroup[index]),
        ),
      ),
    );
  }

  Widget _buildSelectedDiceGroup(OneSelectedDiceGroup selectedDiceGroup) {
    return Column(
      children: [
        selectedDiceGroup.diceGroup.nameWidget,
        _buildSelectedDiceList(selectedDiceGroup.allDice),
      ],
    );
  }

  Widget _buildSelectedDiceList(List<Dice> allSelectedDice) {
    double diceFaceDimension = MediaQuery.of(context).size.width / 2;
    final double diceFacePadding = diceFaceDimension / 20;
    diceFaceDimension -= diceFacePadding;

    Widget buildDiceFace(Dice dice, [EdgeInsetsGeometry? padding]) {
      return dice.getFace(
        dimension: diceFaceDimension,
        index: dice.lastRandFaceIndex,
        padding: padding ?? EdgeInsets.only(bottom: diceFacePadding),
      );
    }

    return Column(
      children: List<Widget>.generate(
        (allSelectedDice.length + 1) ~/ 2,
        (int index) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: (index * 2 + 1 < allSelectedDice.length)
              ? [
                  buildDiceFace(allSelectedDice[index * 2], EdgeInsets.fromLTRB(0, 0, diceFacePadding, diceFacePadding)),
                  buildDiceFace(allSelectedDice[index * 2 + 1]),
                ]
              : [
                  buildDiceFace(allSelectedDice[index * 2]),
                ],
        ),
      ),
    );
  }
}
