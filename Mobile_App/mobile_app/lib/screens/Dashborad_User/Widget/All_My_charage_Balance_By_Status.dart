import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/user/Wallet_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Profile/Profile_User.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/colors.dart';

class ChargeBalanceByStatusPage extends StatefulWidget {
  @override
  _ChargeBalancePageBystatusState createState() =>
      _ChargeBalancePageBystatusState();
}

class _ChargeBalancePageBystatusState extends State<ChargeBalanceByStatusPage> {
  String _selectedStatus = 'padding';
  late String _accessToken;

  @override
  void initState() {
    super.initState();
    _accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
    _fetchData();
  }

  void _fetchData() {
    Provider.of<WalletUserProvider>(context, listen: false)
        .fetchChargeBalances(_selectedStatus, _accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
              result: ModalRoute.withName('/ProfilePage'),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          'Charge Balance',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedStatus,
              items: [
                DropdownMenuItem(
                  child: Text('Pending'),
                  value: 'padding',
                ),
                DropdownMenuItem(
                  child: Text('Completed'),
                  value: 'completed',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
                _fetchData();
              },
            ),
            Expanded(
              child: Consumer<WalletUserProvider>(
                builder: (context, provider, child) {
                  if (provider.isSLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!));
                  } else if (provider.chargeBalances.isEmpty) {
                    return Center(child: Text('No charge balances found.'));
                  } else {
                    return ListView.builder(
                      itemCount: provider.chargeBalances.length,
                      itemBuilder: (context, index) {
                        final chargeBalance = provider.chargeBalances[index];
                        return ChargeBalanceCard(chargeBalance: chargeBalance);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChargeBalanceCard extends StatelessWidget {
  final chargeBalance;

  ChargeBalanceCard({required this.chargeBalance});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(chargeBalance.image),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Points: ${chargeBalance.point}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Status: ${chargeBalance.status}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Time-Order: ${chargeBalance.createdAt}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
