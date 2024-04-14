import 'dart:io';
import 'package:path/path.dart';

int? getNumberFromFileName(String path) {
  int start = path.lastIndexOf('/') + 1;
  int end = path.lastIndexOf('.');
  if (end <= start) {
    end = path.length;
  }
  return int.tryParse(path.substring(start, end));
}


Future<void> copyDirectory(String from, String to) async {
  if (from == to) {
    return;
  } 
  // print("from $from");
  // print("to $to");

  await Directory(to).create(recursive: true);
  await for (final file in Directory(from).list(recursive: true)) {
    final copyTo = join(to, relative(file.path, from: from));
    //print("copyTo $copyTo");
    if (file is Directory) {
      Directory dir = await Directory(copyTo).create(recursive: true);
      //print("new dir ${dir.path}");
    } else if (file is File) {
      File(file.path).copy(copyTo).then((value) {/*print("new fil ${fil.path}");*/});
    }
  }
}