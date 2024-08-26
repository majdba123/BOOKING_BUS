import 'package:flutter/material.dart';

Widget buildDetailColumn(IconData icon, String label) {
  return Column(
    children: [
      Icon(icon, color: Colors.white, size: 24),
      SizedBox(height: 2.0),
      Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    ],
  );
}
