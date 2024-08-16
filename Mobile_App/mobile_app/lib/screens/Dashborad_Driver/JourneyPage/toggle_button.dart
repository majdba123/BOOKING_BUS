import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final double width;
  final Color borderColor;
  final VoidCallback onPressed;

  const ToggleButton({
    required this.label,
    required this.selected,
    required this.width,
    required this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: selected ? Colors.white : borderColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
            color: borderColor,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: borderColor,
                    offset: Offset(0, 3), // Creates the bottom border effect
                    blurRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: selected ? borderColor : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
