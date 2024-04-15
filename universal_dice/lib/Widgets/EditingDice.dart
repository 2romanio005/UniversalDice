import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:universal_dice/Decoration/icons.dart';
import 'package:universal_dice/Decoration/styles.dart';

import 'package:universal_dice/Data/DiceGroup.dart';

Future<bool> showEditingDice(BuildContext context, DiceGroup diceGroup, int diceIndex) {
  late int activeNumberFaces;

  Future<void> functionOK() {
    diceGroup[diceGroup.length - 1].numberFaces = activeNumberFaces;
    return diceGroup.removeDiceAt(diceIndex);
  }

  Future<void> functionOFF() => diceGroup.removeDiceAt();

  return diceGroup.duplicateDice(diceIndex).then((newDice) => showDialog<bool?>(
          context: context,
          builder: (BuildContext context) {
            activeNumberFaces = newDice.numberFaces;
            final controller = TextEditingController();
            controller.text = activeNumberFaces.toString();

            bool displayedFaces = true;
            return StatefulBuilder(
              builder: (context, redraw) {
                // controller.addListener(() => print("c"));
                controller.addListener(() => redraw(() {
                      activeNumberFaces = int.parse(controller.text);
                      if (activeNumberFaces > newDice.numberFaces) {
                        newDice.numberFaces = activeNumberFaces;
                      }
                    }));

                final double diceFaceDimension = MediaQuery.of(context).size.width / 2 - 60;
                final double diceFacePadding = diceFaceDimension / 10;

                Widget buildDiceFace(int index, [EdgeInsetsGeometry? padding]) {
                  return GestureDetector(
                    onTap: () {
                      if (newDice.isFaceImage(index)) {
                        newDice.setFaceFile(index, null).then((_) => redraw(() {}));
                      } else {
                        ImagePicker().pickImage(source: ImageSource.gallery).then(
                              (image) => newDice.setFaceFile(index, image == null ? null : File(image.path)).then((_) => redraw(() {})),
                            );
                      }
                    },
                    child: newDice.getFace(
                      dimension: diceFaceDimension,
                      padding: padding ?? EdgeInsets.only(bottom: diceFacePadding),
                      index: index,
                    ),
                  );
                }

                const int maxDisplayedNumberFaces = 300;
                return AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  // backgroundColor: Theme.of(context).colorScheme.surface,
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  title: const Text("Редактирование кубика", textAlign: TextAlign.center),
                  titleTextStyle: Theme.of(context).textTheme.titleLarge,
                  content: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Expanded(flex: 2, child: Text("Количество граней")),
                                  Expanded(
                                    flex: 1,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      controller: controller,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                        hintStyle: const TextStyle(
                                          //fontFamily: "Consolas",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        hintText: "Было: ${newDice.numberFaces}",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(bottom: 10)),
                              Row(
                                  children: activeNumberFaces > maxDisplayedNumberFaces
                                      ? [
                                          const Text(
                                            "Грани после $maxDisplayedNumberFaces не отображаются.",
                                            style: TextStyle(color: Colors.yellow),
                                          ),
                                        ]
                                      : []),
                              const Padding(padding: EdgeInsets.only(bottom: 10)),
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
                                      return const Text("Изменить изображения на гранях");
                                    },
                                    body: Column(
                                      children: List<Widget>.generate(
                                        min((activeNumberFaces + 1), maxDisplayedNumberFaces) ~/ 2,
                                        (int index) => Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: (index * 2 + 1 < activeNumberFaces)
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
