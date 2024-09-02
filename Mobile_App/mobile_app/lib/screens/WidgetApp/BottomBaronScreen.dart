import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/WidgetApp/filtter_Bar_main_ui.dart';

Widget buildBottomNavBar(BuildContext context) {
  return Positioned(
    left: MediaQuery.of(context).size.width * 0.15,
    right: MediaQuery.of(context).size.width * 0.15,
    bottom: MediaQuery.of(context).size.height * 0.03,
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(35.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: FilterBarUserUi(
        height: 70.0,
        iconSize: 28.0,
      ),
    ),
  );
}
