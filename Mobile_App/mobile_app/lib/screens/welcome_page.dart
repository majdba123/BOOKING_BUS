import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/colors.dart';
import 'package:mobile_app/screens/register_page.dart';
import 'package:mobile_app/screens/signin_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/background_mappp.png", // Path to your PNG background image
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top content (logo, title, and description)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    children: [
                      // Bus Logo at the top
                      SizedBox(height: screenHeight * 0.12),
                      Container(
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        child: SvgPicture.asset(
                          "assets/images/logo_bus.svg", // Path to your logo image
                          fit: BoxFit.contain,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Welcome Title
                      Text(
                        "Welcome to BusX",
                        style: TextStyle(
                          fontSize: screenHeight * 0.045,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Description
                      Text(
                        "Plan your trip, book your seat, and track your bus in real-time with BusX. Your seamless travel experience starts here.",
                        style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Bottom content (Create account and Sign In)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    children: [
                      // Sign In Button with hover effect
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                          backgroundColor:
                              AppColors.primaryColor, // Yellow background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize:
                              Size(double.infinity, 50), // Full-width button
                        ).copyWith(
                          elevation: ButtonStyleButton.allOrNull(0),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return AppColors.primaryColor
                                    .withOpacity(0.9); // Darker yellow on hover
                              }
                              return AppColors.primaryColor; // Default color
                            },
                          ),
                        ),
                        child: Text(
                          'ENTER',
                          style: TextStyle(
                            fontSize: screenHeight * 0.025,
                            color: Colors.white, // White text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
