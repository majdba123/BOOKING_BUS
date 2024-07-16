import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        Text(
          title,
          style: TextStyle(fontFamily: 'Satoshi',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        ElevatedButton(onPressed: (){}, child: Text('all trip')),
      ],
    );
  }
}
