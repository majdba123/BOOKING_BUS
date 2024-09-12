import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

Widget CustomeProgressIndecator(BuildContext context) {
  return SizedBox(
    height: 60.0,
    width: 60.0,
    child: CircularProgressIndicator(
      strokeWidth: 5.0,
      color: AppColors.primaryColor,
    ),
  );
}
