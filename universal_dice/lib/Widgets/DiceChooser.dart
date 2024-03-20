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
          "Выберите игральные кости",
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
                  leading: IconButton(
                    constraints: BoxConstraints(),
                    style: buttonStyleOFF,
                    onPressed: () async {
                      await confirmationBox(
                          context: context,
                          title: 'Удалить группу кубиков?',
                          text: "Группа \"${diceGroup.name}\" будет удалена со всем содержимым.",
                          textOK: 'Удалить группу',
                          textOFF: 'Отмена',
                          functionOK: () {
                            setState(() {
                              diceGroupList.removeDiceGroupAt(index);
                              widget._displayedDictGroup.removeAt(index);
                            });

                            widget.onDelete();
                          });
                    },
                    icon: const Icon(iconButtonDeleteDiceGroup),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
            diceGroup.length,
            (int index) => ListTile(
              title: Text((diceGroup[index].numberFaces).toString(), textAlign: TextAlign.center),
              titleTextStyle: Theme.of(context).textTheme.titleSmall,
              leading: IconButton(
                style: buttonStyleOFF,
                onPressed: () async {
                  await confirmationBox(
                      context: context,
                      title: 'Удалить кубик?',
                      text: "Кубик с ${diceGroup[index].numberFaces} гранями будет удалён.",
                      textOK: 'Удалить',
                      textOFF: 'Отмена',
                      functionOK: () {
                        setState(() {
                          diceGroup.removeDiceAt(index);
                        });

                        widget.onDelete();
                      });
                },
                icon: const Icon(iconButtonDeleteDice),
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
                title: const Text("Новый кубик", textAlign: TextAlign.center),
                titleTextStyle: Theme.of(context).textTheme.titleSmall,
                trailing: Icon(iconButtonAddDice, color: ColorButtonForeground),
                leading: Icon(iconButtonAddDice, color: ColorButtonForeground),
              ),
              onPressed: () {
                setState(() {
                  diceGroup.pushDice(Dice(5)); // TODO создание нового кубика
                });

                widget.onAdd();
              },
            ),
          ],
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
          titleTextStyle: Theme.of(context).textTheme.titleSmall,
          trailing: Icon(iconButtonAddDiceGroup, color: ColorButtonForeground),
          leading: Icon(iconButtonAddDiceGroup, color: ColorButtonForeground),
        ),
        onPressed: () {
          setState(() {
            diceGroupList.addDiceGroup(DiceGroup(name: "New group", diceList: [])); // TODO создание новой группы
            widget._displayedDictGroup.add(true);
          });

          widget.onAdd();
        },
      ),
    );
  }
}
