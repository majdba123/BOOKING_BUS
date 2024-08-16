import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/screens/DashBorad_Company/Bus_managment/Bus_managment.dart';
import 'package:mobile_app/screens/DashBorad_Company/Driver_managment/Driver_managment_page.dart';
import 'package:mobile_app/screens/DashBorad_Company/Private_Trips_Requset.dart';
import 'package:mobile_app/screens/DashBorad_Company/Trip_managemt/trip_managemt_page.dart';
import 'package:mobile_app/screens/DashBorad_Company/path_mangement/path_managemt_page.dart';

import 'package:mobile_app/screens/signin_page.dart';
import 'package:mobile_app/widgets/my_text_button.dart';
import 'package:provider/provider.dart';

class Dashbord extends StatefulWidget {
  @override
  State<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  void _logout(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false)
        .logout(); // Call logout method
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => SignInPage()), // Navigate to login page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Your Name'),
              accountEmail: Text('your.email@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    NetworkImage('https://example.com/your_image.jpg'),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('ادارة مسار '),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Path_managment()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('ادارة الباصات'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Bus_management_Page()));
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('ادارة السائقين'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DriverManagementPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('ادارة الرحلات'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TripBusmanagment()));
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('ادارة الرحلات الخاصة'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivateTripByComapany()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('تسجيل خروج'),
              onTap: () => _logout(context), // Logout functionality
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('واجهة الشركة'),
        centerTitle: true,
      ),
      // backgroundColor: Colors.white,
      body: Center(
        child: Text('this is Dashbord of the company account '),
      ),
    );
  }
}
