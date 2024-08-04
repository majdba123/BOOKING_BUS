// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Rating_Provider.dart';
import 'package:provider/provider.dart';

class RatingDriverUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<RatingUserProvider>(context);
    userProvider.setAccessToken(Provider.of<AuthProvider>(context).accessToken);
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Rating'),
      ),
      body: Expanded(
        child: FutureBuilder(
          future: userProvider.fetchDrivers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: userProvider.drivers.length,
              itemBuilder: (context, index) {
                final driver = userProvider.drivers[index];
                return ListTile(
                  title: Text(driver.user!.name),
                  trailing: IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {
                      _showRatingDialog(context, driver.id, userProvider);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showRatingDialog(
      BuildContext context, int driverId, RatingUserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) {
        int _rating = 1;
        return AlertDialog(
          title: Text('Rate Driver'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select rating:'),
              DropdownButton<int>(
                value: _rating,
                items: List.generate(5, (index) => index + 1)
                    .map((rating) => DropdownMenuItem(
                          value: rating,
                          child: Text(rating.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    _rating = value;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String message =
                    await userProvider.rateDriver(driverId, _rating);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
