import 'package:flutter/material.dart';

class StopDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPassengerRow(Icons.arrow_upward, 'UL11', 'Vignesh', '24 Male'),
            buildPassengerRow(
                Icons.arrow_downward, 'UL12', 'Zashria', '22 Female'),
            buildPassengerRow(Icons.arrow_upward, 'UL13', 'Adlin', '22 Female'),
            buildPassengerRow(
                Icons.arrow_upward, 'UL14', 'Ashley', '22 Female'),
            buildPassengerRow(
                Icons.arrow_upward, 'UL15', 'Zashria', '22 Female'),
            buildPassengerRow(
                Icons.arrow_upward, 'UL16', 'Zashria', '22 Female'),
          ],
        ),
      ),
    );
  }

  Row buildPassengerRow(IconData icon, String id, String name, String details) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon,
                color: icon == Icons.arrow_upward ? Colors.green : Colors.red),
            SizedBox(width: 8),
            Text(id),
            SizedBox(width: 8),
            Text(name),
            SizedBox(width: 8),
            Text(details, style: TextStyle(color: Colors.grey)),
          ],
        ),
        Icon(Icons.phone, color: Colors.grey),
      ],
    );
  }
}
