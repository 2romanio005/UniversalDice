import 'package:flutter/material.dart';
import 'dart:math';

import 'package:universal_dice/Decoration/buttonStyle.dart';
import 'package:universal_dice/Decoration/icons.dart';

import 'package:universal_dice/Data/Dice.dart';
import 'package:universal_dice/Data/DiceGroup.dart';
import 'package:universal_dice/Data/DiceGroupList.dart';

import 'package:universal_dice/Widgets/ConfirmationBox.dart';
import 'package:universal_dice/Widgets/EditingDice.dart';
import 'package:universal_dice/Widgets/EditingDiceGroup.dart';

void _constVoidFunction() {}

class DiceChooserView extends StatefulWidget {
  DiceChooserView({super.key, this.whenChangingTheSelected = _constVoidFunction, this.onSelect = _constVoidFunction, this.onDelete = _constVoidFunction, this.onChange = _constVoidFunction});

  final void Function() whenChangingTheSelected;
  final void Function() onSelect;
  final void Function() onDelete;
  final void Function() onChange;

  final List<bool> _displayedDictGroup = List<bool>.filled(diceGroupList.length, false, growable: true);

  Future<DiceGroup> addNewDiceGroup_addDisplayedDictGroup([bool displayedState = true]) {
    _displayedDictGroup.add(displayedState);
    return diceGroupList.addNewDiceGroup();
  }

  Future<DiceGroup> duplicateDiceGroup_addDisplayedDictGroup(int index, [bool displayedState = true]) {
    _displayedDictGroup.add(displayedState);
    return diceGroupList.duplicateDiceGroup(index);
  }

  Future<bool> removeDiceGroupAt_removeDisplayedDictGroupAt(int index) {
    _displayedDictGroup.removeAt(index);
    return diceGroupList.removeDiceGroupAt(index);
  }

  @override
  State<DiceChooserView> createState() => _DiceChooserView();
}

class _DiceChooserView extends State<DiceChooserView> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildTitle(),
          _buildDictGroupList(),
          _buildingFooter(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          "Выберите используемые кости",
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDictGroupList() {
    return Expanded(
      child: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              widget._displayedDictGroup[index] = !widget._displayedDictGroup[index];
            });
          },
          children: List<ExpansionPanel>.generate(diceGroupList.length, (index) {
            DiceGroup diceGroup = diceGroupList[index];
            return ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: widget._displayedDictGroup[index],
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: diceGroup.nameWidget,
                  leading: PopupMenuButton<int>(
                    position: PopupMenuPosition.under,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    child: const Icon(iconButtonModeDiceGroup),
                    itemBuilder: (context) => [
                      _buildingMoreMenuElement(
                          icon: Icon(iconButtonEditDiceGroup, color: colorButtonForeground),
                          text: "Редактировать",
                          buttonStyle: buttonStyleDefault,
                          onPressed: () {
                            showEditingDiceGroup(context, diceGroup).then((status) {
                              if (status) {
                                Navigator.pop(context);
                                setState(() {});
                                if (diceGroup.state) {
                                  widget.whenChangingTheSelected();
                                }
                                widget.onChange();
                              }
                            });
                          }),
                      _buildingMoreMenuElement(
                        icon: const Icon(iconButtonDuplicateDiceGroup, color: colorButtonPressedOK),
                        text: "Дублировать",
                        buttonStyle: buttonStyleOK,
                        onPressed: () {
                          Navigator.pop(context);
                          widget.duplicateDiceGroup_addDisplayedDictGroup(index).then((diceGroup) {
                            setState(() {});
                            if (diceGroup.state) {
                              widget.whenChangingTheSelected();
                            }
                            widget.onChange();
                          });
                        },
                      ),
                      _buildingMoreMenuElement(
                        icon: const Icon(iconButtonDeleteDiceGroup, color: colorButtonPressedOFF),
                        text: "Удалить",
                        buttonStyle: buttonStyleOFF,
                        onPressed: () {
                          showConfirmationBox(
                              context: context,
                              titleText: 'Удалить группу с игральными костями?',
                              contentText: "Группа \"${diceGroup.name}\" будет удалена со всем содержимым.",
                              textOK: 'Удалить группу',
                              textOFF: 'Отмена',
                              functionOK: () {
                                widget.removeDiceGroupAt_removeDisplayedDictGroupAt(index).then((state) {
                                  Navigator.pop(context);
                                  setState(() {});
                                  widget.onDelete();
                                  if (state) {
                                    widget.whenChangingTheSelected();
                                  }
                                });
                              });
                        },
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: diceGroup.state
                        ? Icon(
                            iconRadioButtonChecked,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : Icon(
                            iconRadioButtonUnchecked,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    onPressed: () => setState(() {
                      diceGroup.invertState();
                      // if (diceGroup.state) {
                      //   widget._displayedDictGroup[index] = true;
                      // }
                      widget.onSelect();
                      widget.whenChangingTheSelected();
                    }),
                  ),
                );
              },
              body: _buildDictList(diceGroup), //Expanded(child: Text("lol")),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDictList(DiceGroup diceGroup) {
    return Container(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(diceGroup.length, (int index) {
                Dice dice = diceGroup[index];

                Widget drawDiceFace([int? index]) {
                  double padding = Theme.of(context).textTheme.titleSmall!.fontSize! / 10;
                  return dice.getFace(
                    index: index,
                    dimension: Theme.of(context).textTheme.titleSmall!.fontSize! * 6 / 5,
                    padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                  );
                }

                return ListTile(
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: dice.numberFaces <= 6
                          ? List<Widget>.generate(
                              max(dice.numberFaces, 1),
                              drawDiceFace,
                            )
                          : [
                              drawDiceFace(0),
                              drawDiceFace(1),
                              Text(
                                " ... ",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              drawDiceFace(dice.numberFaces - 2),
                              drawDiceFace()
                            ],
                    ),
                  ),
                  leading: PopupMenuButton<int>(
                    position: PopupMenuPosition.under,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    child: const Icon(iconButtonModeDice),
                    itemBuilder: (context) => [
                      _buildingMoreMenuElement(
                          icon: Icon(iconButtonEditDice, color: colorButtonForeground),
                          text: "Редактировать",
                          buttonStyle: buttonStyleDefault,
                          onPressed: () {
                            showEditingDice(context, diceGroup, index).then((status) {
                              if (status) {
                                Navigator.pop(context);
                                setState(() {});
                                if (diceGroup[index].state) {
                                  widget.whenChangingTheSelected();
                                }
                                widget.onChange();
                              }
                            });
                          }),
                      _buildingMoreMenuElement(
                        icon: const Icon(iconButtonDuplicateDice, color: colorButtonPressedOK),
                        text: "Дублировать",
                        buttonStyle: buttonStyleOK,
                        onPressed: () {
                          Navigator.pop(context);
                          diceGroup.duplicateDice(index).then((dice) {
                            setState(() {});
                            if (dice.state) {
                              widget.whenChangingTheSelected();
                            }
                            widget.onChange();
                          });
                        },
                      ),
                      _buildingMoreMenuElement(
                        icon: const Icon(iconButtonDeleteDice, color: colorButtonPressedOFF),
                        text: "Удалить",
                        buttonStyle: buttonStyleOFF,
                        onPressed: () {
                          showConfirmationBox(
                              context: context,
                              titleText: 'Удалить игральную кость?',
                              contentText: "Кость с ${dice.numberFaces} гранями будет удалён.",
                              textOK: 'Удалить',
                              textOFF: 'Отмена',
                              functionOK: () {
                                diceGroup.removeDiceAt(index).then((state) {
                                  Navigator.pop(context);
                                  setState(() {});
                                  widget.onDelete();
                                  if (state) {
                                    widget.whenChangingTheSelected();
                                  }
                                });
                              });
                        },
                      ),
                    ],
                  ),
                  trailing: dice.state
                      ? Icon(
                          iconRadioButtonChecked,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Icon(
                          iconRadioButtonUnchecked,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  selected: dice.state,
                  onTap: () {
                    setState(() {
                      dice.invertState();
                    });
                    widget.onSelect();
                    widget.whenChangingTheSelected();
                  },
                );
              }) +
              [
                TextButton(
                  style: buttonStyleOK.merge(
                    IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  child: ListTile(
                    title: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text("Добавить кость", textAlign: TextAlign.center),
                    ),
                    titleTextStyle: Theme.of(context).textTheme.titleSmall?.merge(TextStyle(color: colorButtonForeground)),
                    trailing: Icon(iconButtonAddDice, color: colorButtonForeground),
                    leading: Icon(iconButtonAddDice, color: colorButtonForeground),
                  ),
                  onPressed: () {
                    diceGroup.addStandardDice().then((dice) {
                      setState(() {});
                      if (dice.state) {
                        widget.whenChangingTheSelected();
                      }
                      widget.onChange();
                    });
                  },
                ),
              ],
        ));
  }

  PopupMenuItem<int> _buildingMoreMenuElement({required Icon icon, required String text, required ButtonStyle buttonStyle, required void Function() onPressed}) {
    return PopupMenuItem<int>(
      enabled: false,
      child: TextButton(
        style: buttonStyle.merge(IconButton.styleFrom(padding: const EdgeInsets.fromLTRB(10, 0, 0, 3))),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            const SizedBox(width: 10, height: 10),
            Text(text, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildingFooter() {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      // color: colorBackground,
      child: TextButton(
        style: buttonStyleOK.merge(
          IconButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
        ),
        child: ListTile(
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text("Добавить группу", textAlign: TextAlign.center),
          ),
          titleTextStyle: Theme.of(context).textTheme.titleSmall?.merge(TextStyle(color: colorButtonForeground)),
          trailing: Icon(iconButtonAddDiceGroup, color: colorButtonForeground),
          leading: Icon(iconButtonAddDiceGroup, color: colorButtonForeground),
        ),
        onPressed: () {
          widget.addNewDiceGroup_addDisplayedDictGroup().then((diceGroup) {
            setState(() {});
            if (diceGroup.state) {
              widget.whenChangingTheSelected();
            }
            widget.onChange();
          });
        },
      ),
    );
  }
}
