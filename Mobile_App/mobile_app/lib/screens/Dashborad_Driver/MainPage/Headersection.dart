import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Login+Regsiter/signin_page.dart';
import 'package:mobile_app/screens/Dashborad_User/Profile/NoticationPage.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class HeraderSection extends StatelessWidget {
  void _logout(BuildContext context) {
    // _unsubscribeFromPusher(); // Unsubscribe on logout
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.03,
        horizontal: screenWidth * 0.05,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BusX',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenHeight * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                'Driver Client',
                style: TextStyle(
                  color: Colors.green[400],
                  fontSize: screenHeight * 0.018,
                ),
              ),
            ],
          ),
          Row(
            children: [
              badges.Badge(
                showBadge: true,
                position: badges.BadgePosition.topEnd(
                  top: -1,
                  end: 0,
                ),
                badgeContent: Text(''),
                child: IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => NotificationInboxPage()),
                    );
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: () => _logout(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
