import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

PreferredSizeWidget customeAppBar(
    BuildContext context, String title, List<Widget>? action) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.white,
      onPressed: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/mainPageUser',
          (Route<dynamic> route) => false,
        );
      },
    ),
    centerTitle: true,
    backgroundColor: AppColors.primaryColor,
    title: Text(
      title,
      style: TextStyle(color: Colors.white, fontSize: 22.0),
    ),
    actions: action,
  );
}
