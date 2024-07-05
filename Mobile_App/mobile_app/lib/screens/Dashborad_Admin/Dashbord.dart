import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/Bus_managment/Bus_managment.dart';
import 'package:mobile_app/screens/DashBorad_Company/Driver_managment/Driver_managment_page.dart';

import 'package:mobile_app/screens/DashBorad_Company/Trip_mangement/Trip_managemt_page.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Break_Places_Mnagement/Breack_Place_mangemt.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Company_managemnt/Create_Account_Comany.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Country_managment/Country_Mnagament.dart';



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
              title: Text('ادارة  المناطق'),
              onTap: () {
                // Handle Home button tap

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CountryManagementPage()));
              },
            ),
             ListTile(
              leading: Icon(Icons.home),
              title: Text('ادارة  الاستراحات'),
              onTap: () {
                // Handle Home button tap

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BreakPlaceManagament()));
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('انشاء حساب شركة'),
              onTap: () {
                // Handle Home button tap

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPageCompany()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('واجهة الادمن'),centerTitle: true,),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('this is DashbordAdmin of the Admin account '),
      ),
    );
  }
}
