import 'package:flutter/material.dart';

import 'package:universal_dice/Decoration/styles.dart';

import 'package:universal_dice/Data/Dice.dart';
import 'package:universal_dice/Data/DiceGroupList.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageView();
}

class _HomePageView extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Expanded(child: _buildSelectedDiceGroupList()),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: TextButton(
                style: buttonStyleDefault.merge(
                  IconButton.styleFrom(backgroundColor: ColorButtonBackgroundOnMainPageView),
                ),
                onPressed: () {
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
    List<OneSelectedDiceGroup> allSelectedDiceGroup = diceGroupList.allSelectedDiceGroup;

    return SingleChildScrollView(
      child: Column(
        children: List<Widget>.generate(
          allSelectedDiceGroup.length,
          (index) => _buildSelectedDiceGroup(allSelectedDiceGroup[index]),
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
    diceFaceDimension -= diceFacePadding * 2;

    Widget buildDiceFace(Dice dice, [EdgeInsetsGeometry? padding]) {
      return dice.getFace(
        dimension: diceFaceDimension,
        index: dice.randFaceIndex,
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
                  buildDiceFace(allSelectedDice[index]),
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
