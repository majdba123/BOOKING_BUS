import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/Dashbord.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Dashbord.dart';

import 'package:mobile_app/screens/login/login_ui.dart';
import 'package:mobile_app/constants.dart';

import 'package:mobile_app/screens/welcome_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Sign In Sign Up Ui',
      theme:  ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Dashbord(),
    );
  }
}
