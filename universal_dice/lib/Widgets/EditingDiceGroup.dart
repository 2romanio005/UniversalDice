import 'package:flutter/material.dart';

import 'package:universal_dice/Decoration/buttonStyle.dart';

import 'package:universal_dice/Data/DiceGroup.dart';

Future<bool> showEditingDiceGroup(BuildContext context, DiceGroup diceGroup) {
  final controller = TextEditingController();
  controller.text = diceGroup.name;

  Future<void> functionOK() { return diceGroup.setName(controller.text == "" ? "Пусто" : controller.text);}
  void functionOFF() {}

  return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          // backgroundColor: Theme.of(context).colorScheme.surface,
          actionsAlignment: MainAxisAlignment.spaceAround,
          title: const Text("Редактирование группы", textAlign: TextAlign.center),
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Название группы:"),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Было: ${diceGroup.name}",
                        hintStyle: const TextStyle(
                          //fontFamily: "Consolas",
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          contentTextStyle: Theme.of(context).textTheme.labelMedium,
          actions: [
            ElevatedButton(
              style: buttonStyleOFF,
              child: Text("Отмена", style: Theme.of(context).textTheme.titleSmall),
              onPressed: () {
                Navigator.pop(context, false);

                functionOFF();
              },
            ),
            ElevatedButton(
              style: buttonStyleOK,
              child: Text("Сохранить", style: Theme.of(context).textTheme.titleSmall),
              onPressed: () {
                Navigator.pop(context, true);

                functionOK();
              },
            ),
          ],
        );
      }).then((status) {
    if (status == null) {
      functionOFF();
      return false;
    }
    return status;
  });
}
