import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_dice/Decoration/icons.dart';

import 'package:universal_dice/Decoration/icons.dart';
import 'package:universal_dice/Decoration/styles.dart';

import 'package:universal_dice/Data/Dice.dart';

Future<Dice?> showEditingDiceView(BuildContext context, Dice dice) async {
  Dice resultDice = dice.copy();

  await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            final controller = TextEditingController();
            controller.text = resultDice.numberFaces.toString();

            bool displayedFace = true;
            return StatefulBuilder(
              builder: (context, redraw) {
                // controller.addListener(() => print("c"));

                double daceFaceDimension = MediaQuery.of(context).size.width / 2 - 60;
                double daceFacePadding = daceFaceDimension / 10;

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
                            mainAxisSize: MainAxisSize.min,
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
                                        redraw(() => resultDice.numberFaces = int.parse(controller.text));
                                      },
                                    ),
                                  )
                                ],
                              ),
                              ExpansionPanelList(
                                expansionCallback: (int index, bool isExpanded) {
                                  redraw(() {
                                    displayedFace = !displayedFace;
                                  });
                                },
                                children: [
                                  ExpansionPanel(
                                    canTapOnHeader: true,
                                    isExpanded: displayedFace,
                                    headerBuilder: (BuildContext context, bool isExpanded) {
                                      return Text("Поменять изображения на гранях");
                                    },
                                    body: Column(
                                      children: List<Widget>.generate(
                                        (resultDice.numberFaces + 1) ~/ 2,
                                        (int index) => Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: (index * 2 + 1 < resultDice.numberFaces)
                                              ? [
                                                  resultDice.getFace(
                                                    dimension: daceFaceDimension,
                                                    padding: EdgeInsets.only(bottom: daceFacePadding),
                                                    //padding: EdgeInsets.fromLTRB(daceFacePadding, 0, daceFacePadding / 2, daceFacePadding),
                                                    index: index * 2,
                                                  ),
                                                  resultDice.getFace(
                                                    dimension: daceFaceDimension,
                                                    padding: EdgeInsets.only(bottom: daceFacePadding),
                                                    //padding: EdgeInsets.fromLTRB(daceFacePadding / 2, 0, daceFacePadding, daceFacePadding),
                                                    index: index * 2 + 1,
                                                  ),
                                                ]
                                              : [
                                                  resultDice.getFace(
                                                    dimension: daceFaceDimension,
                                                    padding: EdgeInsets.only(bottom: daceFacePadding),
                                                    index: index * 2,
                                                  ),
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
                        //functionOFF!();
                        Navigator.pop(context, false);
                      },
                    ),
                    ElevatedButton(
                      style: buttonStyleOK,
                      child: Text("Сохранить", style: Theme.of(context).textTheme.titleSmall),
                      onPressed: () {
                        //functionOK!();
                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                );
              },
            );
          }) ??
      false;
}
