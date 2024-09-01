import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/Driver/TripDriver.dart';
import 'package:mobile_app/Provider/user/user_info_profile.dart';
import 'package:mobile_app/screens/Dashborad_Driver/FirstTripcard.dart';
import 'package:mobile_app/screens/Dashborad_User/Login+Regsiter/signin_page.dart';
import 'package:mobile_app/screens/WidgetApp/BottomBaronScreen.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashboardDriver extends StatefulWidget {
  @override
  State<DashboardDriver> createState() => _DashboardDriverState();
}

class _DashboardDriverState extends State<DashboardDriver> {
  void _logout(BuildContext context) {
    // _unsubscribeFromPusher(); // Unsubscribe on logout
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  late UserInfoProvider infoUser;
  late AuthProvider auth;
  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthProvider>(context, listen: false);
    infoUser = Provider.of<UserInfoProvider>(context, listen: false);
    Provider.of<TripDriverProvider>(context, listen: false)
        .fetchFirstTrip(auth.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.05,
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
                          IconButton(
                            icon: Icon(Icons.notifications_sharp,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.logout, color: Colors.white),
                            onPressed: () => _logout(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                // Texts Outside Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Evening ${infoUser.userInfo?.name}',
                        style: TextStyle(
                          fontSize: screenHeight * 0.028,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Here is your upcoming journey',
                        style: TextStyle(
                          fontSize: screenHeight * 0.022,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                FirstTrip(),

                SizedBox(height: screenHeight * 0.03),

                // Stats Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Stats',
                        style: TextStyle(
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.04,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '£${infoUser.userInfo?.points}',
                              style: TextStyle(
                                fontSize: screenHeight * 0.035,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF28A745),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'Total Earnings',
                              style: TextStyle(
                                fontSize: screenHeight * 0.022,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '3.8',
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.028,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'Speed Rating',
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.02,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '4.2',
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.028,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'Driving Rating',
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.02,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: screenHeight * 0.2,
                                  height: screenHeight * 0.2,
                                  child: SfRadialGauge(
                                    axes: <RadialAxis>[
                                      RadialAxis(
                                        minimum: 0,
                                        maximum: 100,
                                        ranges: <GaugeRange>[
                                          GaugeRange(
                                            startValue: 0,
                                            endValue: 50,
                                            color: Colors.red,
                                            startWidth: 10,
                                            endWidth: 10,
                                          ),
                                          GaugeRange(
                                            startValue: 50,
                                            endValue: 75,
                                            color: Colors.orange,
                                            startWidth: 10,
                                            endWidth: 10,
                                          ),
                                          GaugeRange(
                                            startValue: 75,
                                            endValue: 100,
                                            color: Colors.green,
                                            startWidth: 10,
                                            endWidth: 10,
                                          ),
                                        ],
                                        pointers: <GaugePointer>[
                                          NeedlePointer(
                                            value: 78,
                                            needleColor: Colors.black,
                                            needleEndWidth: 5,
                                            lengthUnit: GaugeSizeUnit.factor,
                                            needleLength: 0.6,
                                          ),
                                        ],
                                        annotations: <GaugeAnnotation>[
                                          GaugeAnnotation(
                                            widget: Container(
                                              child: Text(
                                                '78%',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            angle: 90,
                                            positionFactor: 0.5,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  'Driving Score',
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.018,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.12),
              ],
            ),
          ),
          buildBottomNavBar(context),
        ],
      ),
    );
  }
}
