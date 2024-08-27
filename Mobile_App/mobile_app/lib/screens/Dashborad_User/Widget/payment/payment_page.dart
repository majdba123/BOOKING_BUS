import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/payment/PaymentDetails.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/payment/PaymentMethods.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/payment/pay_button.dart.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';


class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Payment'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PaymentDetails(),
                SizedBox(height: 20),
                PaymentMethods(),
                Spacer(),
                // PayButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
