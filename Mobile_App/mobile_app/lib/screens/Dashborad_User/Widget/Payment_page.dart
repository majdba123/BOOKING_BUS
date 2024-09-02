import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Pill_Card_spsecfication/Book_Card_Resvartion_spsecfication.dart';
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
                PayButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PaymentDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Tickets', style: TextStyle(fontSize: 16)),
                Text('£40', style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('1x Seater',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text('£20', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('1x Sleeper',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text('£20', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Taxes & Fees', style: TextStyle(fontSize: 16)),
                Text('£40', style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('VAT (18%)',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text('£20', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('ArrowSpeed Fee (12%)',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text('£20', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('£89',
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

class PaymentMethods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Pay with:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        PaymentMethodCard(),
        // PaymentMethodExpansion(title: 'Wallets'),
        PaymentMethodExpansion(title: 'UPI'),
      ],
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Credit or Debit Cards', style: TextStyle(fontSize: 16)),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Holder',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Exp Date',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Card Verified',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodExpansion extends StatelessWidget {
  final String title;

  PaymentMethodExpansion({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Icon(Icons.keyboard_arrow_down),
      ),
    );
  }
}

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
              var userprovider =
                  Provider.of<TripuserProvider>(context, listen: false);
              print('-------------');
              print(accessToken);
              print(provider.trip_type);
              print(provider.selectedSeat);
              print(provider.selectedBoardingPoint!.breakId);
              print(provider.selectedBus!.busId);

              try {
                await provider.make_reservation(
                    accessToken,
                    provider.trip_type,
                    provider.selectedSeat,
                    provider.selectedBoardingPoint!.breakId,
                    provider.selectedBus!.busId as int);

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
                                    builder: (context) =>
                                        DashboardUser()), // Navigate to login page
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
                                    builder: (context) =>
                                        DashboardUser()), // Navigate to login page
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
            child: Text('Pay £89'),
          ),
        );
      },
    );
  }
}
