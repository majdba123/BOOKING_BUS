import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/Dashbord.dart';

import 'package:mobile_app/screens/register_page.dart';
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
  Future<String> SignIn(var email, var password) async {
    String url = "http://127.0.0.1:8001/api/login";
    print(email);
    print(password);
    var res = await http.post(
      Uri.parse('$url'),
      body: {'email': email, 'password': password},
    );
    print(res.statusCode);
    if (res.statusCode == 200) {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      String accessToken = parsedJson['access_token'];

      return accessToken;
    } else {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      String message = parsedJson['message'];
      return message;
    }
  }

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
                                ));
                        var user_token = await SignIn(
                            emailController.text, passwordController.text);
                        print('the res is $user_token');
                        if (user_token != "Invalid Credentials") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashbord()));

                          showAlertDialog(context, user_token);
                          // Navigator.of(context).pop();
                        } else {
                          showAlertDialog(context, user_token);
                          Navigator.of(context).pop();
                          // Navigator.of(context).pop();
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

showAlertDialog(BuildContext context, String result) {
  // Create button
  print('the result is in shhhh!!!!!!!!!!! $result');
  Widget okButton = ElevatedButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  if (result != "Invalid Credentials") {
    AlertDialog alert = AlertDialog(
      title: Text("Hi"),
      content: Text("Wlcome in your account."),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  } else {
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text("please check your usename or your password"),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
