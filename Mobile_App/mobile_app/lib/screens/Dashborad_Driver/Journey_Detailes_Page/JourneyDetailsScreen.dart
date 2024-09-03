import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/JourneyAppBar.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/JourneyBody.dart';

class JourneyDetailsScreen extends StatefulWidget {
  @override
  _JourneyDetailsScreenState createState() => _JourneyDetailsScreenState();
}

class _JourneyDetailsScreenState extends State<JourneyDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JourneyAppBar(),
      body: JourneyBody(),
    );
  }
}
