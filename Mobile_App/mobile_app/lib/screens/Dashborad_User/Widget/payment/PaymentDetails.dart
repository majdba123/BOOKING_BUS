import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:provider/provider.dart';

class PaymentDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripuserProvider>(context);
    final ticketDetails = tripProvider.selectedTicketDetails;

    return Card(
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
            ...ticketDetails.map((ticket) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${ticket.quantity}x ${ticket.type}',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text('£${ticket.price}',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              );
            }).toList(),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total ',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('£${tripProvider.totalAmount}',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
