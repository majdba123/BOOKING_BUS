import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/Bus_managment/Bus_managment.dart';
import 'package:mobile_app/screens/DashBorad_Company/Driver_managment/Driver_managment_page.dart';

import 'package:mobile_app/screens/DashBorad_Company/Trip_mangement/Trip_managemt_page.dart';



import 'package:mobile_app/widgets/my_text_button.dart';

class DashbordAdmin extends StatefulWidget {
  @override
  State<DashbordAdmin> createState() => _DashbordAdminState();
}

class _DashbordAdminState extends State<DashbordAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
          
            ListTile(
              leading: Icon(Icons.home),
              title: Text('ادارة مسار الرحلات'),
              onTap: () {
                // Handle Home button tap

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Trip_managment()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('ادارة الباصات'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Bus_management_Page()));
             
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('ادارة السائقين'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DriverManagementPage()));
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.info),
            //   title: Text('About'),
            //   onTap: () {
            //     // Handle About button tap
            //     Navigator.pop(context);
            //   },
            // ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('واجهة الشركة'),centerTitle: true,),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('this is DashbordAdmin of the Admin account '),
      ),
    );
  }
}
