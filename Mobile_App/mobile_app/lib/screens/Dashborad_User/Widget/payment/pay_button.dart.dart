import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Pill_Card_spsecfication/Book_Card_Resvartion_spsecfication.dart';

Future<void> makeReservation(BuildContext context) async {
  var accessToken =
      Provider.of<AuthProvider>(context, listen: false).accessToken;

  final provider = Provider.of<TripuserProvider>(context, listen: false);
  var BusTrip = Provider.of<BussofSpsccifTripProvider>(context, listen: false);
  print(accessToken);
  print(BusTrip.selectedTypeTripIndex == 0 ? 1 : 2);
  print(BusTrip.selectedSeat);
  print(BusTrip..selectedBoardingPoint!.breakId);
  print(BusTrip.busResponses[BusTrip.selectIndexOfSpsecifcBustrip].bus_trip_id);
  try {
    await provider.make_reservation(
        accessToken,
        BusTrip.selectedTypeTripIndex == 0 ? 1 : 2,
        BusTrip.selectedSeat,
        BusTrip.selectedBoardingPoint!.breakId,
        BusTrip.busResponses[BusTrip.selectIndexOfSpsecifcBustrip].bus_trip_id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripTicketPage(),
      ),
    );
  } catch (e) {
    if (e.toString().contains('Seat already booking')) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Seat already booking'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => DashboardUser()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => DashboardUser()),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }
}
