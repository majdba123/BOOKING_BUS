import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Book_Card_Resvartion_spsecfication.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';

class PayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TripuserProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              var accessToken =
                  Provider.of<AuthProvider>(context, listen: false).accessToken;

              try {
                await provider.make_reservation(
                    accessToken,
                    provider.trip_type,
                    provider.selectedSeat,
                    provider.selectedBoardingPoint!.breakId,
                    provider.selectedBus!.busId);

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
                                MaterialPageRoute(
                                    builder: (context) => DashboardUser()),
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
                                MaterialPageRoute(
                                    builder: (context) => DashboardUser()),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
            child: Text('Pay £${provider.totalAmount}'),
          ),
        );
      },
    );
  }
}
