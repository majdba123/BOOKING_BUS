import 'package:flutter/material.dart';

class PassengerDetailsScreen extends StatelessWidget {
  final Map bus;

  PassengerDetailsScreen({required this.bus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Passenger Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Boarding and Deboarding points:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Chennai CMBT @ 5:50am'),
              trailing: TextButton(
                onPressed: () {},
                child: Text("Change"),
              ),
            ),
            ListTile(
              title: Text('Bangalore BS @ 11:15am'),
              trailing: TextButton(
                onPressed: () {},
                child: Text("Change"),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              "Passenger details:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Passenger details:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Age",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(),
                    ),
                    items: ['Male', 'Female']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              "Contact details:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                ),
                Text("Send mail and message about the trip details?"),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle payment
              },
              child: Text("Continue to pay"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
