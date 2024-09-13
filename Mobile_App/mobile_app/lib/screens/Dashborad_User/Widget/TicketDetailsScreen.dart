import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/CancelButtonReservation.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/TicketSpecificationCard.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/TrackBusTrip.dart';
import 'package:mobile_app/screens/WidgetApp/AppBar.dart';

class TicketDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customeAppBar(context, 'Ticket Details', null),
      body: Stack(
        children: [
          backImage(context),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: TicketCard(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TrackBusSection(),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CancelButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
