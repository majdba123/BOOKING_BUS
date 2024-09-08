import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/Breck_Strop_screens/PassengerInfoRow.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/scanQr.dart';
import 'package:mobile_app/screens/WidgetApp/BackToTripbutton.dart';
import 'package:provider/provider.dart';

class StopDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var driverProvider = Provider.of<DriverProvider>(context, listen: false);
    var trip = driverProvider.MyTrip?[driverProvider.indextrip];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Stop Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenHeight * 0.025,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * 0.02),
            // Journey Information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${trip?.from} to ${trip?.to}',
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      '${trip?.Passengers} Passengers · ${trip?.Stops} Stops',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenHeight * 0.018,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.025,
                    vertical: screenHeight * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 233, 222),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${trip?.status}',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: screenHeight * 0.015,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),

            // Stop Title and Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stop ${(driverProvider.indexStop) + 1} - ${driverProvider.TripDriverDetail?.breaks_data[driverProvider.indexStop].break_name}',
                  style: TextStyle(
                    fontSize: screenHeight * 0.022,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: screenHeight * 0.03,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),

            // Stop Information Box
            Container(
              padding: EdgeInsets.all(screenHeight * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Information Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.people,
                          color: Colors.grey, size: screenHeight * 0.022),
                      SizedBox(width: screenWidth * 0.015),
                      Text(
                        'Name of Passengers ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.018,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.002),
                      SizedBox(width: screenWidth * 0.015),
                      Icon(Icons.arrow_upward,
                          color: Colors.green, size: screenHeight * 0.022),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Passenger List
                  Column(
                    children: [
                      PassengerListWidget(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),

            if (driverProvider.isStartTrip) ...[
              CustomeButton(context, 'Scan QR ', () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext Context) => QRScanScreen()));
              }),
              CustomeButton(
                  context, 'Back to Trip', () => Navigator.pop(context)),
            ] else if (!driverProvider.isStartTrip) ...[
              CustomeButton(
                  context, 'Back to Trip', () => Navigator.pop(context)),
            ],
          ],
        ),
      ),
    );
  }
}
