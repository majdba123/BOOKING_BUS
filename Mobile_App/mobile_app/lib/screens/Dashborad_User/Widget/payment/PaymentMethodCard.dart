import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:provider/provider.dart';

class PaymentMethodCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripuserProvider>(context);

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('E-wallet', style: TextStyle(fontSize: 16)),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
            SizedBox(height: 10),
            Text('Using: E-wallet ', // Defaults to user's preferred wallet
                style: TextStyle(color: Colors.green)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Change wallet or payment method logic
              },
              child: Text('Change Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
