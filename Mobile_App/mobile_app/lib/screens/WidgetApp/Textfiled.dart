import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

Widget textFiledinput(
    TextEditingController controller, String hintText, String labelText) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
        fontSize: 13,
        color: AppColors.primaryColor,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.indigo,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Color(0xffC2C2C2),
          width: 2.0,
        ),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 13,
        color: Color(0xffA9A9A9),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      fillColor: Colors.white,
      filled: true,
    ),
    keyboardType: TextInputType.text,
  );
}
