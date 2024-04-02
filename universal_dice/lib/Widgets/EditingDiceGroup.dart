import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:universal_dice/Decoration/icons.dart';
import 'package:universal_dice/Decoration/styles.dart';

import 'package:universal_dice/Data/Dice.dart';
import 'package:universal_dice/Data/DiceGroup.dart';

Future<bool> showEditingDiceGroup(BuildContext context, DiceGroup diceGroup) {
  final controller = TextEditingController();
  controller.text = diceGroup.name;

  void functionOK() => diceGroup.name = controller.text == "" ? "Пусто" : controller.text;
  void functionOFF() {}

  return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          // backgroundColor: Theme.of(context).colorScheme.surface,
          actionsAlignment: MainAxisAlignment.spaceAround,
          title: Text("Редактирование группы", textAlign: TextAlign.center),
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
          content: Row(
            children: [
              const Expanded(child: Text("Название группы")),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Напишите название",
                  ),
                ),
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
