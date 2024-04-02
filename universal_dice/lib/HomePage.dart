import 'package:flutter/material.dart';
import 'package:universal_dice/Decoration/styles.dart';
import 'dart:math';

import 'package:universal_dice/Widgets/HomePageView.dart';

import 'package:universal_dice/Widgets/DiceChooserView.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
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
      onSelect: redraw,
      onDelete: redraw,
      onChange: () {
        //editingModeController.enableEditingMode();
        redraw();
      },
    );
  }

  void openDrawer(void Function() open) {
    open();
    /*if (editingModeController.isNotEditMode) {
      open();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        showCloseIcon: true,
        duration: Duration(milliseconds: 500),
        dismissDirection: DismissDirection.none,
        content: Text("Сначала сохраните стихотворение", textAlign: TextAlign.center),
      ));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      drawer: drawer,

      //body: Text("test"),//HomePageView(), // не добавлять const а то всё перестаёт обновляться
      body:
      Column(
        children: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.abc)),
          f
              ? IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              if(await ff()) {
                setState(() {});
              }
            },
          )
              : Image.file(File(pat)),
        ],
      ),

    );
  }
}

String pat = "";

Future<bool> ff() async {
  XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (image == null) return false;

  // Step 3: Get directory where we can duplicate selected file.
  var d = await getApplicationDocumentsDirectory();
  final String duplicateFilePath = d.path;

// Step 4: Copy the file to a application document directory.
  final fileName = basename(image.path);
  pat = "$duplicateFilePath/$fileName";
  await image.saveTo(pat);

  final List<FileSystemEntity> entities = await d.list(recursive: false).toList();
  final Iterable<File> files = entities.whereType<File>();

  for (File file in files) {
    print("File!!! " + file.path);
  }
  f = false;
return true;
/*  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('test_image', localImage.path)

// Step 2: Loading image by using the path that we saved earlier. We can create a file using path
//         and can use FileImage provider for loading image from file.
  CircleAvatar(
      backgroundImage: FileImage(File(prefs.getString('test_image')),
  radius: 50,
  backgroundColor: Colors.white)*/
}

bool f = true;
