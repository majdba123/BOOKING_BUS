import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Driver/RatingDriverAndSpeed.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/Provider/user/user_info_profile.dart';
import 'package:mobile_app/screens/Dashborad_Driver/MainPage/DrivingScoreSpeed.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class StateSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    UserInfoProvider infoUser =
        Provider.of<UserInfoProvider>(context, listen: false);
    return Consumer<DriverProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (provider.errorMessage != null) {
        return Center(
          child: Text('Error: ${provider.errorMessage}'),
        );
      }
      RateDriverModel? rateDriver = provider.RateDriver;
      if (rateDriver == null) {
        return Center(
          child: Text('No Rate available'),
        );
      }

      return Padding(
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
                            '${rateDriver.Speed_Rateing}',
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
                            '${rateDriver.Driving_Rateing}',
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
                      SizedBox(width: 20),
                      drivingScore(),
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
      );
    });
  }
}
