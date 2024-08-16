import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Widget navigateTo;

  const SectionTitle({
    required this.title,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Satoshi',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => navigateTo),
            );
          },
          child: Text('All'),
        ),
      ],
    );
  }
}
