import 'package:flutter/material.dart';

enum DialogAction {yes, no}

class DialogAlert {
  static Future<DialogAction> yesNoDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx){
        return AlertDialog(
          title: Text(
            title, 
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold, 
              color: Colors.teal
              ),
            ),
          content: Text(body),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),            
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(ctx).pop(DialogAction.yes), 
              child: const Text(
                'Ok, Entendi!',
                style: TextStyle(fontSize: 16, color: Colors.teal),
              )
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.no;
  }
}