import 'package:flutter/material.dart';
import 'package:mobile_app/colors.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConfirmButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor: AppColors.primaryColor,
        ),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Text(
            'Confirm',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
