import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:mobile_app/screens/DashBorad_Company/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';


import 'package:mobile_app/screens/register_page.dart';
import 'package:mobile_app/widgets/Alert_Box.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../widgets/widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
            width: 24,
            color: Colors.white,
            image: Svg('assets/images/back_arrow.svg'),
          ),
        ),
      ),
      body: SafeArea(
        //to make page scrollable
        child: CustomScrollView(
          reverse: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back.",
                            style: kHeadline,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "You've been missed!",
                            style: kBodyText2,
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          MyTextField(
                            TextController: emailController,
                            hintText: 'Phone, email or username',
                            inputType: TextInputType.text,
                          ),
                          MyPasswordField(
                            passwordController: passwordController,
                            isPasswordVisible: isPasswordVisible,
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Dont't have an account? ",
                          style: kBodyText,
                        ),
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
                            'Register',
                            style: kBodyText.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: 'Sign In',
                     onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.setAuthData(emailController.text, passwordController.text);

                        Navigator.of(context).pop(); // Close the progress indicator

                        if (authProvider.accessToken.isNotEmpty) {
                          // Determine which dashboard to navigate to based on user type
                          Widget destinationPage;
                          if (authProvider.userType == "company") {
                            destinationPage = Dashbord();
                          } else if (authProvider.userType == "user") {
                            destinationPage =DashbordUser();
                          } else if (authProvider.userType == "driver") {
                            destinationPage = DashbordDriver();
                          } else if (authProvider.userType == "admin") {
                            destinationPage = DashbordAdmin();
                          } else {
                            // Handle unexpected user type
                            showAlertDialog(context, "Unexpected user type: ${authProvider.userType}");
                            return;
                          }
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => destinationPage),
                          );
                        } else {
                          showAlertDialog(context, "Invalid Credentials");
                        }
                      },
                      bgColor: Colors.white,
                      textColor: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

