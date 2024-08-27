import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

void showCustomAlertDialog(BuildContext context, String content) {
  Widget okButton = ElevatedButton(
    child: Text(
      "OK",
      style: TextStyle(color: Colors.white),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    title: Row(
      children: [
        SizedBox(width: 10),
        Text(
          'Alert',
          style: TextStyle(
            // color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    content: Text(
      content,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    ),
    actions: [
      Center(
        child: okButton,
      ),
    ],
    backgroundColor: Colors.white,
    elevation: 10,
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
