import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:universal_dice/Decoration/icons.dart';
import 'package:universal_dice/Decoration/styles.dart';

import 'package:universal_dice/Data/DiceGroup.dart';

Future<bool> showEditingDice(BuildContext context, DiceGroup diceGroup, int diceIndex) {
  Future<void> functionOK() => diceGroup.removeDiceAt(diceIndex);
  Future<void> functionOFF() => diceGroup.removeDiceAt();

  return diceGroup.duplicateDice(diceIndex).then((newDice) => showDialog<bool?>(
          context: context,
          builder: (BuildContext context) {
            final controller = TextEditingController();
            controller.text = newDice.numberFaces.toString();

            bool displayedFaces = true;
            return StatefulBuilder(
              builder: (context, redraw) {
                // controller.addListener(() => print("c"));

                final double diceFaceDimension = MediaQuery.of(context).size.width / 2 - 60;
                final double diceFacePadding = diceFaceDimension / 10;

                Widget buildDiceFace(int index, [EdgeInsetsGeometry? padding]) {
                  return GestureDetector(
                    onTap: () {
                      ImagePicker().pickImage(source: ImageSource.gallery).then(
                            (image) => newDice.setFaceFile(index, image == null ? null : File(image.path)).then((_) => redraw(() {})),
                          );
                    },
                    child: newDice.getFace(
                      dimension: diceFaceDimension,
                      padding: padding ?? EdgeInsets.only(bottom: diceFacePadding),
                      index: index,
                    ),
                  );
                }

                return AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  // backgroundColor: Theme.of(context).colorScheme.surface,
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  title: Text("Редактирование кубика", textAlign: TextAlign.center),
                  titleTextStyle: Theme.of(context).textTheme.titleLarge,
                  content: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Expanded(flex: 5, child: Text("Количество граней")),
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      controller: controller,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: const InputDecoration(
                                        hintText: "Напишите количество граней",
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      style: buttonStyleOK,
                                      icon: const Icon(iconButtonChangeNumberDiceFaces),
                                      onPressed: () {
                                        redraw(() => newDice.numberFaces = int.parse(controller.text));
                                      },
                                    ),
                                  )
                                ],
                              ),
                              ExpansionPanelList(
                                expansionCallback: (int index, bool isExpanded) {
                                  redraw(() {
                                    displayedFaces = !displayedFaces;
                                  });
                                },
                                children: [
                                  ExpansionPanel(
                                    canTapOnHeader: true,
                                    isExpanded: displayedFaces,
                                    headerBuilder: (BuildContext context, bool isExpanded) {
                                      return Text("Изменить изображения на гранях");
                                    },
                                    body: Column(
                                      children: List<Widget>.generate(
                                        (newDice.numberFaces + 1) ~/ 2,
                                        (int index) => Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: (index * 2 + 1 < newDice.numberFaces)
                                              ? [
                                                  buildDiceFace(index * 2),
                                                  buildDiceFace(index * 2 + 1),
                                                ]
                                              : [
                                                  buildDiceFace(index * 2),
                                                ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  contentTextStyle: Theme.of(context).textTheme.labelMedium,
                  actions: [
                    ElevatedButton(
                      style: buttonStyleOFF,
                      child: Text("Отмена", style: Theme.of(context).textTheme.titleSmall),
                      onPressed: () {
                        functionOFF().then((_) => Navigator.pop(context, false));
                        //functionOFF!();
                      },
                    ),
                    ElevatedButton(
                      style: buttonStyleOK,
                      child: Text("Сохранить", style: Theme.of(context).textTheme.titleSmall),
                      onPressed: () {
                        print("OK");
                        functionOK().then((_) => Navigator.pop(context, true));
                        //functionOK!();
                      },
                    ),
                  ],
                );
              },
            );
          }).then((status) {
        if (status == null) {
          print("error");
          return functionOFF().then((_) => false);
        }
        return status;
      }));
}
