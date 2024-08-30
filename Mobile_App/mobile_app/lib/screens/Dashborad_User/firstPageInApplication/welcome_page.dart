import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/colors.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Login+Regsiter/signin_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    void initState() {
      super.initState();
      precacheImage(AssetImage("assets/images/background_mappp.png"), context);
      precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, "assets/images/logo_bus.svg"),
        null,
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/background_mappp.png",
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.12),
                      Container(
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.2,
                        child: SvgPicture.asset(
                          "assets/images/logo_bus.svg",
                          fit: BoxFit.contain,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context, animetedRoutePage(SignInPage()));
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
