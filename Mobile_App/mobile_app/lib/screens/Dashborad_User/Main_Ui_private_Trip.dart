import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_User/Get_private_trip_By_Status.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/map.dart';

class MainUiPrivateTripPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'Private Trip',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 32),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.primaryColor, // Text color
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      elevation: 5, // Button shadow
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapUI()),
                      );
                    },
                    child: Text(
                      'Create Private Trip',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.primaryColor, // Text color
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      elevation: 5, // Button shadow
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrivateTripByStatus()),
                      );
                    },
                    child: Text(
                      'Get Private Trip By Status',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
