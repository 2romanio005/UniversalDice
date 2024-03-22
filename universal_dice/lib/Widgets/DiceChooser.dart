import 'package:flutter/material.dart';

import 'package:universal_dice/Decoration/styles.dart';
import 'package:universal_dice/Decoration/icons.dart';

import 'package:universal_dice/Data/Dice.dart';
import 'package:universal_dice/Data/DiceGroup.dart';
import 'package:universal_dice/Data/DiceGroupList.dart';

import 'package:universal_dice/Widgets/ConfirmationBox.dart';

class DiceChooser extends StatefulWidget {
  DiceChooser({super.key, required this.onSelect, required this.onDelete, required this.onAdd});

  final void Function() onSelect;
  final void Function() onDelete;
  final void Function() onAdd;

  final List<bool> _displayedDictGroup = List<bool>.filled(diceGroupList.length, false, growable: true);

  void push_diceGroupList_displayedDictGroup(DiceGroup diceGroup, bool displayedState) {
    diceGroupList.addDiceGroup(diceGroup);
    _displayedDictGroup.add(displayedState);
  }

  void remove_diceGroupList_displayedDictGroup(int index) {
    diceGroupList.removeDiceGroupAt(index);
    _displayedDictGroup.removeAt(index);
  }

  @override
  _DiceChooser createState() => _DiceChooser();
}

class _DiceChooser extends State<DiceChooser> {
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
          "Выберите используемые кубики",
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
                  title: Text(diceGroup.name, textAlign: TextAlign.center),
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  leading: PopupMenuButton<int>(
                    position: PopupMenuPosition.under,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    child: const Icon(iconButtonModeDiceGroup),
                    itemBuilder: (context) => [
                      _buildingMoreMenuElement(
                          icon: Icon(iconButtonEditDiceGroup, color: ColorButtonForeground),
                          text: "Редактировать",
                          buttonStyle: buttonStyleDefault,
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onSelect();
                          }),
                      _buildingMoreMenuElement(
                        icon: const Icon(iconButtonDuplicateDiceGroup, color: ColorButtonPressedOK),
                        text: "Дублировать",
                        buttonStyle: buttonStyleOK,
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            widget.push_diceGroupList_displayedDictGroup(diceGroupList[index].copy(), true);
                          });

                          widget.onAdd();
                        },
                      ),
                      _buildingMoreMenuElement(
                        icon: const Icon(iconButtonDeleteDiceGroup, color: ColorButtonPressedOFF),
                        text: "Удалить",
                        buttonStyle: buttonStyleOFF,
                        onPressed: () async {
                          await confirmationBox(
                              context: context,
                              title: 'Удалить группу кубиков?',
                              text: "Группа \"${diceGroup.name}\" будет удалена со всем содержимым.",
                              textOK: 'Удалить группу',
                              textOFF: 'Отмена',
                              functionOK: () {
                                Navigator.pop(context);
                                setState(() {
                                  widget.remove_diceGroupList_displayedDictGroup(index);
                                });

                                widget.onDelete();
                              });
                        },
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () => setState(() {
                      diceGroup.invertState();
                      if (diceGroup.state) {
                        widget._displayedDictGroup[index] = true;
                      }
                    }),
                    icon: diceGroup.state
                        ? Icon(
                            iconRadioButtonChecked,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : Icon(
                            iconRadioButtonUnchecked,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
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
          children: List<Widget>.generate(
                diceGroup.length,
                (int index) => ListTile(
                  title: Container(
                    alignment: Alignment.center,
                    child: diceGroup[index].getFace(Theme.of(context).textTheme.titleSmall!.fontSize!),
                  ),
                  leading: PopupMenuButton<int>(
                    position: PopupMenuPosition.under,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    child: const Icon(iconButtonModeDice),
                    itemBuilder: (context) => [
                      _buildingMoreMenuElement(
                          icon: Icon(iconButtonEditDice, color: ColorButtonForeground),
                          text: "Редактировать",
                          buttonStyle: buttonStyleDefault,
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onSelect();
                          }),
                      _buildingMoreMenuElement(
                        icon: const Icon(iconButtonDuplicateDice, color: ColorButtonPressedOK),
                        text: "Дублировать",
                        buttonStyle: buttonStyleOK,
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            diceGroup.pushDice(diceGroup[index].copy());
                          });

                          widget.onAdd();
                        },
                      ),
                      _buildingMoreMenuElement(
                        icon: const Icon(iconButtonDeleteDice, color: ColorButtonPressedOFF),
                        text: "Удалить",
                        buttonStyle: buttonStyleOFF,
                        onPressed: () async {
                          await confirmationBox(
                              context: context,
                              title: 'Удалить кубик?',
                              text: "Кубик с ${diceGroup[index].numberFaces} гранями будет удалён.",
                              textOK: 'Удалить',
                              textOFF: 'Отмена',
                              functionOK: () {
                                Navigator.pop(context);
                                setState(() {
                                  diceGroup.removeDiceAt(index);
                                });

                                widget.onDelete();
                              });
                        },
                      ),
                    ],
                  ),
                  trailing: diceGroup[index].state
                      ? Icon(
                          iconRadioButtonChecked,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Icon(
                          iconRadioButtonUnchecked,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  selected: diceGroup[index].state,
                  onTap: () {
                    setState(() {
                      diceGroup[index].invertState();
                    });
                    widget.onSelect();
                  },
                ),
              ) +
              [
                TextButton(
                  style: buttonStyleOK.merge(
                    IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  child: ListTile(
                    title: Text("Новый кубик", textAlign: TextAlign.center),
                    titleTextStyle: Theme.of(context).textTheme.titleSmall?.merge(TextStyle(color: ColorButtonForeground)),
                    trailing: Icon(iconButtonAddDice, color: ColorButtonForeground),
                    leading: Icon(iconButtonAddDice, color: ColorButtonForeground),
                  ),
                  onPressed: () {
                    setState(() {
                      diceGroup.pushDice(Dice(500)); // TODO создание нового кубика
                    });

                    widget.onAdd();
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
      // color: ColorBackground,
      child: TextButton(
        style: buttonStyleOK.merge(
          IconButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
        ),
        child: ListTile(
          title: const Text("Новая группа", textAlign: TextAlign.center),
          titleTextStyle: Theme.of(context).textTheme.titleSmall?.merge(TextStyle(color: ColorButtonForeground)),
          trailing: Icon(iconButtonAddDiceGroup, color: ColorButtonForeground),
          leading: Icon(iconButtonAddDiceGroup, color: ColorButtonForeground),
        ),
        onPressed: () {
          setState(() {
            widget.push_diceGroupList_displayedDictGroup(DiceGroup(name: "New group", diceList: []), true); // TODO создание новой группы
          });

          widget.onAdd();
        },
      ),
    );
  }
}
