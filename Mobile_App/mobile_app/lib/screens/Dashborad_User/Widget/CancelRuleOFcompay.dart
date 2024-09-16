import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/MyBooking/cancelRuleBYcompany.dart';
import 'package:provider/provider.dart';

void showCancelRuleDialog(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

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
                'Cancel a Reservation',
                style: TextStyle(
                  fontSize: screenHeight * 0.025,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Are you sure you want to cancel this Reservation?',
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
                          'Please check the cancel Rule of the Company before canceling.',
                          style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CanceltionRule(),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final userProvider = Provider.of<TripuserProvider>(
                            context,
                            listen: false);
                        final auth =
                            Provider.of<AuthProvider>(context, listen: false);
                        userProvider.CancelReservation(
                            auth.accessToken,
                            userProvider
                                .Myreservations[
                                    userProvider.specificIndexReservation]
                                .id);
                        showSuccessDialog(context,
                            'Your request is being processed by the company',
                            () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/mainPageUser', (route) => false);
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenHeight * 0.01),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cancel Reservation',
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
