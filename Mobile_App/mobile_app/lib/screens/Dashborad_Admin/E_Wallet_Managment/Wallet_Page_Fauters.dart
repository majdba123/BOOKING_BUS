// screens/charge_requests_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Admin/charge_blanace_requsert_provider.dart';
import 'package:mobile_app/screens/Dashborad_Admin/E_Wallet_Managment/spscfic_charge_balance_page.dart';
import 'package:provider/provider.dart';

class ChargeRequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch all charge requests when the screen is loaded
    Provider.of<ChargeRequestProvider>(context, listen: false)
        .fetchChargeRequests(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Charge Balance Requests'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChargeRequestProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (provider.requests.isEmpty) {
                  return Center(child: Text('No charge requests found.'));
                }
                return ListView.builder(
                  itemCount: provider.requests.length,
                  itemBuilder: (context, index) {
                    final request = provider.requests[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: Image.network(
                            request.image), // Adjusted to imageLink
                        title: Text('User ID: ${request.userId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${request.status}'),
                            Text(
                                'Points: ${request.point}'), // Adjusted to points
                            // Text('Created At: ${request.createdAt}'),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Provider.of<ChargeRequestProvider>(context,
                                    listen: false)
                                .acceptChargeRequest(context, request.id);
                          },
                          child: Text('Accept'),
                        ),
                        // : null,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChargeRequestDetailScreen(
                                  requestId: request.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
