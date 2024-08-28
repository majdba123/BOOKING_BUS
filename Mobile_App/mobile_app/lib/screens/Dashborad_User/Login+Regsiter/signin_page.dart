import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/colors.dart';
import 'package:mobile_app/screens/DashBorad_Company/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/Login+Regsiter/ProfileCheckPage.dart';
import 'package:mobile_app/screens/Dashborad_User/Login+Regsiter/register_page.dart';
import 'package:mobile_app/widgets/Alert_Box.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
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
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                        "Sign to BusX",
                        style: TextStyle(
                          fontSize: screenHeight * 0.04, //  for fit
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        "Plan your trip, book your seat, and track your bus in real-time with BUSX.",
                        style: TextStyle(
                          fontSize: screenHeight * 0.018,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelStyle:
                                const TextStyle(color: AppColors.primaryColor),
                            labelText: 'Email or Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.person),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle:
                                const TextStyle(color: AppColors.primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          AuthProvider authProvider =
                              Provider.of<AuthProvider>(context, listen: false);
                          await authProvider.setAuthData(
                              emailController.text, passwordController.text);
                          if (authProvider.accessToken.isNotEmpty) {
                            final tripProvider = Provider.of<TripuserProvider>(
                                context,
                                listen: false);
                            await tripProvider
                                .getallTrips(authProvider.accessToken);
                            await tripProvider
                                .getAllcompanies(authProvider.accessToken);
                          }

                          Navigator.of(context).pop();

                          if (authProvider.accessToken.isNotEmpty) {
                            Widget destinationPage;
                            if (authProvider.userType == "company") {
                              destinationPage = Dashbord();
                            } else if (authProvider.userType == "user") {
                              destinationPage = ProfileCheckPage();
                            } else if (authProvider.userType == "driver") {
                              destinationPage = DashboardDriver();
                            } else if (authProvider.userType == "admin") {
                              destinationPage = DashbordAdmin();
                            } else {
                              showCustomAlertDialog(
                                context,
                                "Unexpected user type: ${authProvider.userType}",
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => destinationPage),
                            );
                          } else {
                            showCustomAlertDialog(
                                context, "Invalid Credentials");
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  screenHeight * 0.025), // Slightly larger
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              const BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: screenHeight * 0.025,
                              color: Colors.white, // White text
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Register Link
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Don't have an account? Register",
                          style: TextStyle(
                            fontSize: screenHeight * 0.018,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Terms and Privacy Policy Text
                      Text(
                        "By signing in, you agree to our Privacy Policy and Terms and Conditions",
                        style: TextStyle(
                          fontSize: screenHeight * 0.015,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.04),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
