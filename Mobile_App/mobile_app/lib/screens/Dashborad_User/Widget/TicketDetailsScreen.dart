import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/CancelButtonReservation.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/TicketSpecificationCard.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/TrackBusTrip.dart';
import 'package:mobile_app/screens/WidgetApp/AppBar.dart';
import 'package:mobile_app/widgets/CustomeCirculerProgress.dart';
import 'package:provider/provider.dart';

class TicketDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var provider = context.read<TripuserProvider>();
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
                Text('Track your bus'.toUpperCase(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(
                  height: 8.0,
                ),
                Consumer<TripuserProvider>(
                  builder: (context, provider, child) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: provider.isLoading
                          ? Center(
                              child: CustomeProgressIndecator(context),
                            )
                          : Stack(
                              children: [
                                Container(
                                  height: 300,
                                  child: TrackBusSection(),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 2,
                                  child: ElevatedButton(
                                    child: Text(
                                      'Open in Map',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TrackBusSection(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      backgroundColor: AppColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
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
