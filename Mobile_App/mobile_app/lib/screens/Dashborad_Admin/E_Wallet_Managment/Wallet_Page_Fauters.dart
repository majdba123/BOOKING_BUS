// screens/charge_requests_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Admin/charge_blanace_requsert_provider.dart';
import 'package:mobile_app/screens/Dashborad_Admin/E_Wallet_Managment/spscfic_charge_balance_page.dart';
import 'package:provider/provider.dart';

class ChargeRequestsScreen extends StatefulWidget {
  @override
  _ChargeRequestsScreenState createState() => _ChargeRequestsScreenState();
}

class _ChargeRequestsScreenState extends State<ChargeRequestsScreen> {
  String _selectedStatus = 'padding'; // Default status to 'padding'

  @override
  void initState() {
    super.initState();
    // Fetch requests based on the default status when the screen is first loaded
    Provider.of<ChargeRequestProvider>(context, listen: false)
        .fetchChargeRequestsByStatus(context, _selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChargeRequestProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Charge Balance Requests'),
      ),
      body: Column(
        children: [
          // DropdownButton for selecting request status
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedStatus,
              items: [
                DropdownMenuItem(value: 'padding', child: Text('Pending')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStatus = value;
                  });
                  // Fetch requests based on the selected status
                  provider.fetchChargeRequestsByStatus(
                      context, _selectedStatus);
                }
              },
            ),
          ),
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
                          request.image, // Use image link
                        ),
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
                        trailing: _selectedStatus == 'padding' &&
                                request.status == 'padding'
                            ? ElevatedButton(
                                onPressed: () {
                                  provider.acceptChargeRequest(
                                      context, request.id);
                                },
                                child: Text('Accept'),
                              )
                            : null,
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
