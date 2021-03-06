import 'package:flutter/material.dart';

import '../constants.dart';

enum PopUpAction { yes, no }

class PopUp {
  static Future<PopUpAction> yesCancelDialog(
      BuildContext context,
      String title,
      String body,
      String optionNo,
      String optionYes,
      ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              onPressed: () =>
                  Navigator.of(context).pop(PopUpAction.no),
              child: Text(
                optionNo,
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(PopUpAction.yes),
              child: Text(
                optionYes,
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.w700),
              ),
            )
          ],
        );
      },);
    return (action != null) ? action : PopUpAction.no;
  }
}