import 'package:flutter/material.dart';
import 'package:my_flutter_app/constants.dart';

//This is an Alert dialog which is displayed when the used is making an attempt to go back from the first question
class ShowAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(quiz),
      content: Text(exitMessage),
      actions: <Widget>[
        FlatButton(
          child: Text(optionYes),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        FlatButton(
          child: Text(optionNo),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
