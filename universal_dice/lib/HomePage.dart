import 'package:flutter/material.dart';
import 'dart:math';

import 'package:universal_dice/Widgets/HomePageView.dart';

import 'package:universal_dice/Decoration/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  void redraw() {
    setState(() {});
  }

  void openDrawer(void Function() open) {
    if (editingModeController.isNotEditMode) {
      open();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        showCloseIcon: true,
        duration: Duration(milliseconds: 500),
        dismissDirection: DismissDirection.none,
        content: Text("Сначала сохраните стихотворение", textAlign: TextAlign.center),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBackground,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => openDrawer(() => Scaffold.of(context).openDrawer()),
          ),
        ),
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            "Universal Dice",
            style: TextStyle(
              fontFamily: "Oswald",
              color: ColorHeader,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      drawer: PoemChooser(
        onSelect: redraw,
        onDelete: redraw,
        onAdd: () {
          editingModeController.enableEditingMode();
          redraw();
        },
      ),

      body: HomePageView(), // не добавлять const а то всё перестаёт обновляться
    );
  }
}
