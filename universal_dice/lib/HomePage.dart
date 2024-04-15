import 'package:flutter/material.dart';
import 'dart:math';

import 'package:universal_dice/Decoration/styles.dart';
import 'package:universal_dice/Decoration/icons.dart';

import 'package:universal_dice/Widgets/HomePageView.dart';
import 'package:universal_dice/Data/DiceGroupList.dart';
import 'package:universal_dice/Widgets/DiceChooserView.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  void redraw() {
    setState(() {});
  }

  late DiceChooserView drawer;

  @override
  void initState() {
    super.initState();
    drawer = DiceChooserView(
      whenChangingTheSelected: redraw,
    );
  }

  void openDrawer(void Function() open) {
    open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            padding: const EdgeInsets.all(16),
            style: buttonStyleDefaultInverted,
            icon: const Icon(iconButtonDrawer),
            onPressed: () => openDrawer(() => Scaffold.of(context).openDrawer()),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              padding: const EdgeInsets.all(16),
              style: buttonStyleDefaultInverted,
              icon: const Icon(iconButtonDrawer),
              onPressed: () => openDrawer(() => Scaffold.of(context).openEndDrawer()),
              //tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            "Универсальные игральные кости",
            style: TextStyle(
              fontFamily: "Oswald",
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      drawer: drawer,
      endDrawer: drawer,
      body: HomePageView(allSelectedDiceGroup: diceGroupList.allSelectedDiceGroup),
    );
  }
}
