import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}

class PolicyText extends StatelessWidget {
  final String text;

  PolicyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class PolicyDetail extends StatelessWidget {
  final String detail;

  PolicyDetail(this.detail);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
      child: Text(
        detail,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
