import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final double fontSize;

  const SectionHeader({
    required this.title,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
    );
  }
}
