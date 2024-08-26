import 'package:flutter/material.dart';

Widget buildIconWithText(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, color: Colors.white, size: 16),
      SizedBox(width: 4.0),
      Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    ],
  );
}
