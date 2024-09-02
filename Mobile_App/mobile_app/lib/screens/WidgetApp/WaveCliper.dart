import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    // Starting point of the path
    path.lineTo(0, size.height - 30);

    // First curve
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 30);

    // Second curve
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height - 60, size.width, size.height - 30);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
