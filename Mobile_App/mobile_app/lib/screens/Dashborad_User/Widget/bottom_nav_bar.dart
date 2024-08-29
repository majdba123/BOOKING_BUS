import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/User/Private_trip.dart';
import 'package:mobile_app/screens/Dashborad_User/Main_Ui_private_Trip.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Private_trip_user.dart';
import 'package:mobile_app/screens/Dashborad_User/Profile/Profile_User.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Color(0xFF003144)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.directions_bus_rounded),
            color: Color(0xFF003144),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainUiPrivateTripPage(),
                ),
              );
            },
          ),
          label: 'Private Trip',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.person, color: Color(0xFF003144)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
          ),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Color(0xFF003144),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    );
  }
}
