import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/screens/DashBorad_Company/Bus_managment/Bus_managment.dart';
import 'package:mobile_app/screens/DashBorad_Company/Driver_managment/Driver_managment_page.dart';
import 'package:mobile_app/screens/DashBorad_Company/path_mangement/path_managemt_page.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Break_Places_Mnagement/Breack_Place_mangemt.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Company_managemnt/Create_Account_Comany.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Country_managment/Country_Mnagament.dart';
import 'package:mobile_app/screens/Dashborad_Admin/E_Wallet_Managment/Wallet_Page_Fauters.dart';

import 'package:mobile_app/screens/Dashborad_User/Login+Regsiter/signin_page.dart';
import 'package:mobile_app/widgets/my_text_button.dart';
import 'package:provider/provider.dart';

class DashbordAdmin extends StatefulWidget {
  @override
  State<DashbordAdmin> createState() => _DashbordAdminState();
}

class _DashbordAdminState extends State<DashbordAdmin> {
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
            ListTile(
              leading: Icon(Icons.home),
              title: Text('ادارة  المناطق'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CountryManagementPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('ادارة  الاستراحات'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BreakPlaceManagament()));
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('انشاء حساب شركة'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterPageCompany()));
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('ادارة المحفظة الالكترونية'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChargeRequestsScreen()));
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
        title: Text('واجهة الادمن'),
        centerTitle: true,
      ),
      // backgroundColor: Colors.white,
      body: Center(
        child: Text('this is DashbordAdmin of the Admin account '),
      ),
    );
  }
}
