import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final List<Widget> items;

  const HorizontalList({required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items,
      ),
    );
  }
}
