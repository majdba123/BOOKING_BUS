import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/CompleteJourneyPage/JourneyCompletedScreen.dart';
import 'package:provider/provider.dart';

class JourneyButtons extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  // final bool isJourneyComplete;

  JourneyButtons({
    required this.screenHeight,
    required this.screenWidth,
    // required this.isJourneyComplete,
  });

  @override
  Widget build(BuildContext context) {
    var driverProvider = Provider.of<DriverProvider>(context, listen: false);
    var auth = Provider.of<AuthProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                print(
                    'the current stop index  ${driverProvider.currentStopIndex}');
                driverProvider.accessBreak(
                    context,
                    auth.accessToken,
                    driverProvider
                        .TripDriverDetail!
                        .breaks_data[driverProvider.currentStopIndex]
                        .pivoit_id);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                ),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenHeight * 0.01),
                ),
              ),
              child: Text(
                'Acess Brack',
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                print(
                    'the current stop index  ${driverProvider.currentStopIndex}');
                print(driverProvider.TripDriverDetail!
                    .breaks_data[driverProvider.currentStopIndex].break_name);
                print(driverProvider.TripDriverDetail!
                    .breaks_data[driverProvider.currentStopIndex].pivoit_id);
                await driverProvider.finishBreack(
                    context,
                    auth.accessToken,
                    driverProvider
                        .TripDriverDetail!
                        .breaks_data[driverProvider.currentStopIndex]
                        .pivoit_id);
                print(
                    'the stops array  ${driverProvider.TripDriverDetail!.breaks_data.length}');
                print(
                    'the current stop index  ${driverProvider.currentStopIndex}');

                if ((driverProvider.TripDriverDetail?.breaks_data.length)! ==
                    driverProvider.currentStopIndex) {
                  if (driverProvider.selectedTypeTripIndex == 1) {
                    driverProvider.setCurrentStopIndex(0);
                  }
                  driverProvider
                      .setCurrentStopIndex(driverProvider.currentStopIndex - 1);
                  _showEndJourneyDialog(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                ),
                backgroundColor: Colors.green,
                // isJourneyComplete ?
                // : Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenHeight * 0.01),
                ),
              ),
              child: Text(
                'Finish Break',
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                  color: Colors.grey.shade700,
                  // isJourneyComplete ? Colors.white
                  //  :
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEndJourneyDialog(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var driverProvider = Provider.of<DriverProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenHeight * 0.02),
          ),
          child: Padding(
            padding: EdgeInsets.all(screenHeight * 0.03),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ' ${driverProvider.selectedTypeTripIndex == 0 ? 'End Going Trip' : 'End OutGoing Journey'}',
                  style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Are you sure you want to end the Trip?',
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: screenHeight * 0.015,
                          color: Colors.black54,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: Text(
                            'Please check every passenger has left the bus.',
                            style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: screenHeight * 0.015,
                          color: Colors.black54,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: Text(
                            'Check for any belongings of passengers.',
                            style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigate to JourneyCompletedScreen
                          // var driverProvider = Provider.of<DriverProvider>(
                          //     context,
                          //     listen: false);
                          // // driverProvider.setStartTrip(false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JourneyCompletedScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              screenHeight * 0.01,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'End Journey',
                              style: TextStyle(
                                fontSize: screenHeight * 0.02,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black87,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
