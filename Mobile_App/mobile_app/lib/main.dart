import 'package:flutter/material.dart';
import 'package:mobile_app/Screen/login/login_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booking_Bus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const login_ui(),
    );
  }
}
