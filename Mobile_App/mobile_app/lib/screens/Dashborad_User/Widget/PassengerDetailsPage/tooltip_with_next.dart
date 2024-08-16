import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TooltipWithNext extends StatelessWidget {
  final String text;
  final VoidCallback onNext;

  const TooltipWithNext({
    required this.text,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.white,
            child: Text(
              text,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            child: Lottie.asset(
              'assets/images/arrow.json',
              width: 150,
              height: 300,
              repeat: true,
            ),
          ),
        ],
      ),
    );
  }
}
