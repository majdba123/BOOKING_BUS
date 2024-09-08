import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:provider/provider.dart';

class FilterBarUserUi extends StatelessWidget {
  final double height;
  final double iconSize;

  const FilterBarUserUi({
    required this.height,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white, size: iconSize),
            onPressed: () {
              if (auth.userType == "user") {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/mainPageUser', (Route<dynamic> route) => false);
              } else if (auth.userType == "driver") {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/driverPageUser', (Route<dynamic> route) => false);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.airplane_ticket,
                color: Colors.white, size: iconSize),
            onPressed: () {
              print(auth.userType);
              if (auth.userType == "user") {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/BookingUser', (Route<dynamic> route) => false);
              } else if (auth.userType == "driver") {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/JourneysScreen', (Route<dynamic> route) => false);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white, size: iconSize),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/ProfilePage', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
