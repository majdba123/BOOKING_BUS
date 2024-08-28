import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final VoidCallback onSearch;

  const SearchButton({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onSearch,
      backgroundColor: Colors.white,
      child: Icon(Icons.search, color: Colors.black),
    );
  }
}
