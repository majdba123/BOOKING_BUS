import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';

import 'package:mobile_app/screens/signin_page.dart';
import 'package:mobile_app/widgets/my_text_button.dart';
import 'package:provider/provider.dart';

class DashbordDriver extends StatefulWidget {
  @override
  State<DashbordDriver> createState() => _DashbordDriverState();
}

class _DashbordDriverState extends State<DashbordDriver> {
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
              title: Text('ادارة مسار الرحلات'),
              onTap: () {
                // Handle Home button tap
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => Trip_managment()));
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
      appBar: AppBar(title: Text('واجهة السائق'), centerTitle: true),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('this is DashbordDriverd of the driver account '),
      ),
    );
  }
}
