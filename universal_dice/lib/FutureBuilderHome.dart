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

    //var directory = await getApplicationDocumentsDirectory();

    //print("lol ${directory.listSync(recursive: true).toList().toString()}");

/*    try {
      File? f = await File("/data/user/0/com.example.universal_dice/app_flutter/2PERkcXFh0Y.jpg");
      print(f.path);
      if(!f.existsSync()){
        print("null");
      }
      await f.delete();
      print("d");
    }catch(err){
      print(err);
    }*/

    //print("start:");
    //poemList = await PoemList.create(); // загрузка предыдущих стихов
    //print("prefin: ${poemList.selectedPoem.title}");
    //await Future.delayed(Duration(seconds: 5));
    //print("fin: ${poemList.selectedPoem.title}");

    Directory dir = await getApplicationDocumentsDirectory();
    await for (final file in dir.list(recursive: true)) {
      print(file.path);
    }
    print("===================");
    diceGroupList = await DiceGroupList.creatingFromFiles();
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
          Widget children = HomePage();
          if (snapshot.hasData) {
            children = HomePage();
          } else if (snapshot.hasError) {
            print("err");
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
            children = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
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
