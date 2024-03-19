import 'package:flutter/material.dart';

import 'package:universal_dice/Decoration/colors.dart';
import 'package:universal_dice/Decoration/styles.dart';

import 'package:universal_dice/Data/Dice.dart';
import 'package:universal_dice/Data/DiceGroup.dart';
import 'package:universal_dice/Data/DiceGroupList.dart';

import 'package:universal_dice/Widgets/ConfirmationBox.dart';

class DiceChooser extends StatefulWidget {
  const DiceChooser({super.key, required this.onSelect, required this.onDelete, required this.onAdd});

  final void Function() onSelect;
  final void Function() onDelete;
  final void Function() onAdd;

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
                diceGroupList[index].invertState();
              });
            },
            children: diceGroupList.map<ExpansionPanel>((DiceGroup dictGroup) {
              return ExpansionPanel(
                isExpanded: dictGroup.state,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(dictGroup.name),
                  );
                },
                body: _buildDictList(dictGroup),
              );
            }).toList(),
          ),
        ),
    );
  }

  Widget _buildDictList(DiceGroup dictGroup) {
    return Container(
      color: ColorBackground,
      child: ListView.builder(
          padding: const EdgeInsets.only(top: 5),
          itemCount: dictGroup.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text((dictGroup[index].numberFaces).toString(), textAlign: TextAlign.center),
              titleTextStyle: Theme.of(context).textTheme.titleSmall,
              trailing: const Icon(Icons.delete),
              leading: Icon(dictGroup[index].state ? (Icons.radio_button_checked) : (Icons.radio_button_unchecked)),
              // FIXME возмонжо не будет менятьса иконка
              selected: dictGroup[index].state,
              onTap: () {
                setState(() {
                  dictGroup[index].invertState();
                });
                widget.onSelect();
              },
            );
          }),
    );
  }

  Widget _buildingFooter() {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      color: ColorBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            style: buttonStyleOK,
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                //diceGroupList; // TODO добавить новую группу
              });
              widget.onAdd();
            },
          ),
          IconButton(
            style: buttonStyleOFF,
            icon: const Icon(Icons.delete_forever_sharp),
            onPressed: () async {
              await confirmationBox(
                  context: context,
                  title: 'Удалить все стихотворения?',
                  text: "Все стихотворения будут удалены.",
                  textOK: 'Удалить все',
                  textOFF: 'Отмена',
                  functionOK: () {
                    setState(() {
                      diceGroupList.clear();  // TODO добавить заглушку
                    });

                    widget.onDelete();
                    //Navigator.pop(context);  // закрытие окна выбора стиха
                  });
            },
          ),
        ],
      ),
    );
  }
}
