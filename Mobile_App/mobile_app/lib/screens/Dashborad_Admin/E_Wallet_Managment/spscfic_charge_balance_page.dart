// screens/charge_request_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Admin/charge_blanace_requsert_provider.dart';
import 'package:provider/provider.dart';

class ChargeRequestDetailScreen extends StatelessWidget {
  final int requestId;

  ChargeRequestDetailScreen({required this.requestId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChargeRequestProvider>(context, listen: false);
    provider.fetchChargeRequestDetails(context, requestId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Charge Request Details'),
      ),
      body: Consumer<ChargeRequestProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.selectedRequest == null) {
            return Center(child: Text('No details found.'));
          }

          final request = provider.selectedRequest!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ID: ${request.userId}',
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Image.network(
                    'http://127.0.0.1:8000/storage/app/public/order_balance/yqEK9qHi5brm6wQeeU6TtHmLJK3oFLQR.png'),
                SizedBox(height: 10),
                Text('Status: ${request.status}',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('Points: ${request.point}',
                    style: TextStyle(fontSize: 16)),
                // SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
