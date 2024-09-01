import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Rating_Provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/PositionedMessage.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Data_Models/Driver.dart';

class RatingDriverUi extends StatefulWidget {
  @override
  _RatingDriverUiState createState() => _RatingDriverUiState();
}

class _RatingDriverUiState extends State<RatingDriverUi> {
  late Future<void> _fetchDriversFuture;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider =
        Provider.of<RatingUserProvider>(context, listen: false);
    userProvider.setAccessToken(authProvider.accessToken);
    _fetchDriversFuture = userProvider.fetchDrivers();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<RatingUserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Rating'),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: _fetchDriversFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return ListView.builder(
                itemCount: userProvider.drivers.length,
                itemBuilder: (context, index) {
                  final driver = userProvider.drivers[index];
                  return DriverCard(driver: driver, userProvider: userProvider);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCustomMessage(
      BuildContext context, String message, IconData icon, Color color) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) =>
          PositionedMessage(message: message, icon: icon, color: color),
    );

    overlay?.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

class DriverCard extends StatelessWidget {
  final Driver driver;
  final RatingUserProvider userProvider;

  const DriverCard({required this.driver, required this.userProvider});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    // driver.user?.profileImageUrl ??
                    'https://via.placeholder.com/150', // Placeholder image URL
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.user?.name ?? 'Unknown Driver',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Company: ${driver.company?.nameCompany ?? 'Unknown Company'}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'E-mail: ${driver.user!.email}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.star_border, color: Colors.amber),
                onPressed: () async {
                  int previousRating =
                      await userProvider.getDriverRating(driver.id);
                  _showRatingDialog(
                      context, driver.id, userProvider, previousRating);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context, String driverId,
      RatingUserProvider userProvider, int previousRating) {
    showDialog(
      context: context,
      builder: (context) {
        int _rating = previousRating;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Rate Driver'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select rating:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (_rating == previousRating) {
                      Navigator.of(context).pop();
                      _showCustomMessage(
                          context,
                          'You must change the rating to submit.',
                          Icons.error,
                          Colors.red);
                    } else {
                      String message =
                          await userProvider.rateDriver(driverId, _rating);
                      Navigator.of(context).pop();
                      _showCustomMessage(
                          context, message, Icons.check_circle, Colors.green);
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCustomMessage(
      BuildContext context, String message, IconData icon, Color color) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) =>
          PositionedMessage(message: message, icon: icon, color: color),
    );

    overlay?.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

class CustomMessageWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;

  const CustomMessageWidget(
      {required this.message, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 30.0),
          SizedBox(width: 10.0),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
