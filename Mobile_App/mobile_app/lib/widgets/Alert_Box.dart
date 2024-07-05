import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String result) {
  // Create button
  print('the result is in shhhh!!!!!!!!!!! $result');
  Widget okButton = ElevatedButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  print(result.isNotEmpty);
  if (result.isNotEmpty==true ) {
    AlertDialog alert = AlertDialog(
      title: Text("success"),
      content: Text("$result created successfully"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  } else {
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(result),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}