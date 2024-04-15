import 'package:flutter/material.dart';
import 'package:universal_dice/HomePage.dart';

import 'package:universal_dice/Decoration/styles.dart';

import 'package:universal_dice/Data/DiceGroupList.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class FutureBuilderHome extends StatefulWidget {
  const FutureBuilderHome({super.key});

  @override
  State<FutureBuilderHome> createState() => _FutureBuilderHome();
}

// класс для ожидания загрузки стихов из памяти (можно грузить что угодно до основного экрана)
class _FutureBuilderHome extends State<FutureBuilderHome> {
  Future<bool> _loading() async {
    Directory dir = await getApplicationDocumentsDirectory();
    await for (final file in dir.list(recursive: true)) {
      print(file.path);
    }
    print("===================");

    diceGroupList = await DiceGroupList.creatingFromFiles();

    if(diceGroupList.length == 0){
      await diceGroupList.addNewDiceGroup();
      diceGroupList[0].name = "Стандартная группа";
      Future<void> addDice(int numberFaces) async{
        await diceGroupList[0].addStandardDice();
        diceGroupList[0][diceGroupList[0].length - 1].numberFaces = numberFaces;
      }
      await addDice(2);
      await addDice(6);
      await addDice(10);
    }

    print("loaded");

    return true;
  }

  late final Future<bool> future = _loading();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<bool>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          Widget children = const HomePage();
          if (snapshot.hasData) {
            children = const HomePage();
          } else if (snapshot.hasError) {
            children = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Ошибка: ${snapshot.error}',
                        style: TextStyle(color: Colors.red, fontSize: 24.0)),
                  ),
                ],
              ),
            );
          } else {
            children = const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Загрузка кубиков...',
                        style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
            );
          }
          return children; //children;
        },
      ),
    );
  }
}
