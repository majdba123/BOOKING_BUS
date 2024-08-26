import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

class DeckSwitch extends StatelessWidget {
  final bool showUpperDeck;
  final ValueChanged<bool> onToggle;

  const DeckSwitch({
    Key? key,
    required this.showUpperDeck,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Lower Deck', style: TextStyle(fontSize: 16)),
          Switch(
            value: showUpperDeck,
            onChanged: onToggle,
            activeColor: AppColors.primaryColor,
          ),
          const Text('Upper Deck', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
