import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:provider/provider.dart';

class PaymentDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Payment details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Consumer<BussofSpsccifTripProvider>(
              builder: (context, busTripProvider, child) {
                final ticketDetails = busTripProvider.selectedTicketDetails;
                return Column(
                  children: <Widget>[
                    ...ticketDetails.map((ticket) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('${ticket.quantity}x ${ticket.type}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            Text('£${ticket.price}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                      );
                    }).toList(),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Total ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('£${busTripProvider.totoal_price}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
