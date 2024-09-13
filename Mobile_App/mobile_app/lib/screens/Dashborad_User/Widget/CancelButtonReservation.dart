import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

class CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Handle cancel ticket action
      },
      icon: Icon(
        Icons.cancel,
        color: Colors.white,
      ),
      label: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          'Cancel Ticket',
          style: TextStyle(color: Colors.white),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
