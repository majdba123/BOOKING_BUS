import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:mobile_app/screens/login/UserPage/Dashbord.dart';

class login_ui extends StatefulWidget {
  const login_ui({Key? key}) : super(key: key);

  @override
  State<login_ui> createState() => login_uiState();
}

class login_uiState extends State<login_ui> {
  @override
  Future<String> login_company(var email, var password) async {
    String url = "http://127.0.0.1:8001/api/login";

    var res = await http.post(
      Uri.parse('$url'),
      body: {'email': email, 'password': password},
    );
    Map<String, dynamic> parsedJson = json.decode(res.body);
    String accessToken = parsedJson['access_token'];

    // print(accessToken);

    return accessToken;
  }

  bool _passwordInVisible = true;
  @override
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    // IconButton(
                    //     onPressed: () {
                    //       Navigator.pushAndRemoveUntil(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => Homescreen()),
                    //           (route) => false);
                    //     },
                    //     icon: Icon(Icons.arrow_back)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                alignment: Alignment.center,
                child: const CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  // backgroundImage: AssetImage('images/login.jpg'),
                ),
              ),
            ]),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                " قم بتسجيل الدخول",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF113953),
                    fontSize: 38,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        hintText: "اسم المستخدم ", labelText: "اسم المستخدم"),

                    // InputDecoration(
                    //     border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(30.0)),
                    //     prefixIcon: Icon(Icons.person),
                    //     hintText: 'enter your name'),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  width: 500,
                  margin: EdgeInsets.only(left: 10.0, top: 10.0),
                  child: TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: "كلمة السر",
                      labelText: "كلمة السر",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordInVisible
                              ? Icons.visibility_off
                              : Icons
                                  .visibility, //change icon based on boolean value
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordInVisible =
                                !_passwordInVisible; //change boolean value
                          });
                        },
                      ),
                    ),
                    // InputDecoration(
                    //     border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(30.0)),
                    //     prefixIcon: Icon(Icons.password),
                    //     hintText: 'enter your password'),
                    obscureText: _passwordInVisible,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                      alignment: Alignment.topRight,
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'هل نسيت كلمة السر ؟',
                          style: TextStyle(color: Colors.black87),
                        ),
                      )),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(20.0),
                      ),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) => Center(
                                  child: CircularProgressIndicator(),
                                ));
                        var user_token = await login_company(
                            emailController.text, passwordController.text);
                        print('the res is $user_token');
                        if (user_token.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashbord()));

                          showAlertDialog(context, user_token);
                          // Navigator.of(context).pop();
                        } else {
                          showAlertDialog(context, user_token);
                          // Navigator.of(context).pop();
                        }

                        // print(emailController.text);
                        // print(passwordController.text);
                      },
                      child: Text(
                        "login",
                      )),
                ),
              ],
            )
          ],
        ),
      ]),
    ));
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
  if (result.isNotEmpty) {
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
