import 'package:flutter/material.dart';

import 'package:universal_dice/Decoration/styles.dart';

Future<bool> showConfirmationBox({
  required BuildContext context,
  String titleText = "",
  Widget? title,
  String contentText = "",
  Widget? content,
  required String textOK,
  required String textOFF,
  void Function()? functionOK,
  void Function()? functionOFF,
}) {
  functionOK ??= () {};
  functionOFF ??= () {};
  title ??= Text(titleText, textAlign: TextAlign.center);
  content ??= Text(contentText);

  return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          actionsAlignment: MainAxisAlignment.spaceAround,
          title: title,
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          content: content,
          contentTextStyle: Theme.of(context).textTheme.labelMedium,
          actions: [
            ElevatedButton(
              style: buttonStyleOFF,
              child: Text(textOFF, style: Theme.of(context).textTheme.titleSmall),
              onPressed: () {
                Navigator.pop(context, false);
                functionOFF!();
              },
            ),
            ElevatedButton(
              style: buttonStyleOK,
              child: Text(textOK, style: Theme.of(context).textTheme.titleSmall),
              onPressed: () {
                Navigator.pop(context, true);
                functionOK!();
              },
            ),
          ],
        );
      }).then((status) {
    if (status == null) {
      functionOFF!();
      return false;
    }
    return status;
  });
}
