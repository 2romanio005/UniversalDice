import 'package:flutter/material.dart';
import 'dart:math';

import 'package:universal_dice/Decoration/curves.dart';
import 'package:universal_dice/Decoration/buttonStyle.dart';

import 'package:universal_dice/Data/Dice.dart';
import 'package:universal_dice/Data/DiceGroupList.dart';

class HomePageView extends StatefulWidget {
  HomePageView({super.key, required this.allSelectedDiceGroup}) {
    for (SelectedDiceGroup selectedDiceGroup in allSelectedDiceGroup) {
      for (Dice dice in selectedDiceGroup.allDice) {
        dice.lastRandFaceIndex = null;
      }
    }
  }

  @override
  State<StatefulWidget> createState() => _HomePageView();

  final List<SelectedDiceGroup> allSelectedDiceGroup;
}

class _HomePageView extends State<HomePageView> with TickerProviderStateMixin {
  late List<_DiceGroupAnimations> allDiceGroupAnimations;

  @override
  void initState() {
    super.initState();
    //print("Количество выбранных граней ${widget.allSelectedDiceGroup.last.length}");

    allDiceGroupAnimations = List<_DiceGroupAnimations>.generate(
        widget.allSelectedDiceGroup.length,
        (index) => _DiceGroupAnimations(
              length: widget.allSelectedDiceGroup[index].length,
              vsync: this,
            ));

    for (_DiceGroupAnimations diceGroupAnimations in allDiceGroupAnimations) {
      diceGroupAnimations.allForward(from: 0);
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (_DiceGroupAnimations diceGroupAnimations in allDiceGroupAnimations) {
      diceGroupAnimations.dispose();
    }
  }

  void _checkIfTheNumberOfAnimationsMatches() {
    //print("checkIfTheNumberOfAnimationsMatches ${widget.allSelectedDiceGroup.length}");
    for (int i = 0; i < widget.allSelectedDiceGroup.length; i++) {
      if (i < allDiceGroupAnimations.length) {
        //print("updated $i");
        // обновление количества контроллеров в остающейся группе
        allDiceGroupAnimations[i].checkTheLengthMatch(widget.allSelectedDiceGroup[i].length);
      } else {
        //print("add $i");
        // добавление недостающих групп контроллеров
        allDiceGroupAnimations.add(_DiceGroupAnimations(length: widget.allSelectedDiceGroup[i].length, vsync: this));
      }
    }
    // удаление лишних групп контроллеров
    if (widget.allSelectedDiceGroup.length < allDiceGroupAnimations.length) {
      for (int i = widget.allSelectedDiceGroup.length; i < allDiceGroupAnimations.length; i++) {
        //print("deleted $i");
        allDiceGroupAnimations[i].dispose();
      }
      allDiceGroupAnimations.length = widget.allSelectedDiceGroup.length;
    }
    //print("new length is ${allDiceGroupAnimations.length}");
  }

  @override
  Widget build(BuildContext context) {
    _checkIfTheNumberOfAnimationsMatches();

    const double padding = 20;
    return widget.allSelectedDiceGroup.isEmpty
        ? const Padding(
            padding: EdgeInsets.fromLTRB(padding, 100, padding, 0),
            child: Text(
              "Выберите какие игральные кости кидать, нажав на кнопку в верхнем углу потянув меню сбоку.",
              textAlign: TextAlign.center,
            ),
          )
        : Row(
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
                        for (SelectedDiceGroup selectedDiceGroup in widget.allSelectedDiceGroup) {
                          for (Dice dice in selectedDiceGroup.allDice) {
                            dice.generateRandFaceIndex();
                          }
                        }
                        for (_DiceGroupAnimations diceGroupAnimations in allDiceGroupAnimations) {
                          diceGroupAnimations.allForward(from: 0);
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
          (index) => _buildSelectedDiceGroup(widget.allSelectedDiceGroup[index], allDiceGroupAnimations[index]),
        ),
      ),
    );
  }

  Widget _buildSelectedDiceGroup(SelectedDiceGroup selectedDiceGroup, _DiceGroupAnimations diceGroupAnimations) {
    return Column(
      children: [
        selectedDiceGroup.diceGroup.nameWidget,
        _buildSelectedDiceList(selectedDiceGroup.allDice, diceGroupAnimations),
      ],
    );
  }

  Widget _buildSelectedDiceList(List<Dice> allSelectedDice, _DiceGroupAnimations diceGroupAnimations) {
    double diceFaceDimension = MediaQuery.of(context).size.width / 2;
    final double diceFacePadding = diceFaceDimension / 20;
    diceFaceDimension -= diceFacePadding;

    Widget buildDiceFace(int index, [EdgeInsetsGeometry? padding]) {
      Dice dice = allSelectedDice[index];
      AnimationController controller = diceGroupAnimations.allControllers[index];
      Animation<double> animation = diceGroupAnimations.allAnimations[index];

      return GestureDetector(
        onDoubleTap: () {
          dice.generateRandFaceIndex();
          controller.forward(from: 0);
          setState(() {});
        },
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: animation.value,
              child: Container(
                child: dice.getFace(
                  dimension: diceFaceDimension,
                  index: dice.lastRandFaceIndex,
                  padding: padding ?? EdgeInsets.only(bottom: diceFacePadding),
                ),
              ),
            );
          },
        ),
      );
    }

    return Column(
      children: List<Widget>.generate(
        (allSelectedDice.length + 1) ~/ 2,
        (int index) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: (index * 2 + 1 < allSelectedDice.length)
              ? [
                  buildDiceFace(index * 2, EdgeInsets.fromLTRB(0, 0, diceFacePadding, diceFacePadding)),
                  buildDiceFace(index * 2 + 1),
                ]
              : [
                  buildDiceFace(index * 2),
                ],
        ),
      ),
    );
  }
}

/// Класс обёртка для одного контролера и его анимации
class _DiceGroupAnimations {
  _DiceGroupAnimations({required int length, required this.vsync}) {
    allControllers = List<AnimationController>.empty(growable: true);
    allAnimations = List<Animation<double>>.empty(growable: true);
    for (int i = 0; i < length; i++) {
      _addOneAnimation();
    }
  }

  void _addOneAnimation() {
    allControllers.add(AnimationController(
      vsync: vsync,
      //duration: Duration(milliseconds: 2000 + Random().nextInt(1000)),
      duration: Duration(milliseconds: 1500 + Random().nextInt(1000)),
    ));

    Curve curve;
    switch(Random().nextInt(4)){
      case 0:
        curve = CurveCubicBezier(1,1.17,.79,1.24);
      case 1:
        curve = CurveCubicBezier(.01,.56,.15,1.28);
      case 2:
        curve = CurveCubicBezier(.8,1.19,1,.99);
      default:
        curve = Curves.elasticOut;
    }
    allAnimations.add(Tween<double>(begin: 0, end: pi * 2 * (1 + Random().nextInt(2))).animate(
      CurvedAnimation(
        parent: allControllers.last,
        curve: curve,
      ),
    ));
    //print("added anim $length");

  }

  void _popOneAnimation() {
    //print("deleted anim $length");
    allAnimations.removeLast();
    allControllers.last.dispose();
    allControllers.removeLast();
  }

  void dispose() {
    while (length != 0) {
      _popOneAnimation();
    }
  }

  void checkTheLengthMatch(int length) {
    void Function() foo;
    if (this.length < length) {
      foo = _addOneAnimation;
    } else {
      foo = _popOneAnimation;
    }

    while (this.length != length) {
      foo();
    }
  }

  void allForward({required double from}) {
    for (AnimationController controller in allControllers) {
      controller.forward(from: from);
    }
  }

  int get length {
    return allControllers.length;
  }

  late List<AnimationController> allControllers;
  late List<Animation<double>> allAnimations;

  final TickerProvider vsync;
}

