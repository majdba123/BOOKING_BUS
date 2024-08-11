import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_app/colors.dart';
import 'package:mobile_app/screens/DashBorad_Company/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';
import 'package:mobile_app/screens/register_page.dart';
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
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
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

                      // Welcome Text
                      Text(
                        "Sign to BusX",
                        style: TextStyle(
                          fontSize:
                              screenHeight * 0.04, // Adjusted for better fit
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Description Text
                      Text(
                        "Plan your trip, book your seat, and track your bus in real-time with BUSX.",
                        style: TextStyle(
                          fontSize: screenHeight * 0.018,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Email Input Field
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
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
                            labelText: 'Email or Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.person),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Password Input Field
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.lock),
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
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Sign In Button
                      InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          AuthProvider authProvider =
                              Provider.of<AuthProvider>(context, listen: false);
                          await authProvider.setAuthData(
                              emailController.text, passwordController.text);

                          Navigator.of(context)
                              .pop(); // Close the progress indicator

                          if (authProvider.accessToken.isNotEmpty) {
                            // Determine which dashboard to navigate to based on user type
                            Widget destinationPage;
                            if (authProvider.userType == "company") {
                              destinationPage = Dashbord();
                            } else if (authProvider.userType == "user") {
                              destinationPage = DashboardUser();
                            } else if (authProvider.userType == "driver") {
                              destinationPage = DashboardDriver();
                            } else if (authProvider.userType == "admin") {
                              destinationPage = DashbordAdmin();
                            } else {
                              // Handle unexpected user type
                              showAlertDialog(context,
                                  "Unexpected user type: ${authProvider.userType}");
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => destinationPage),
                            );
                          } else {
                            showAlertDialog(context, "Invalid Credentials");
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
                              BoxShadow(
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
