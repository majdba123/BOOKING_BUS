import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

class FilterBarJorney extends StatelessWidget {
  final double height;
  final double iconSize;

  const FilterBarJorney({
    required this.height,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white, size: iconSize),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.airplane_ticket,
                color: Colors.white, size: iconSize),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white, size: iconSize),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
