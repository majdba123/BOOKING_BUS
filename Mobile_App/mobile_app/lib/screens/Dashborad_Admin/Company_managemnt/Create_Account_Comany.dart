import 'package:flutter/material.dart';

import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:mobile_app/constants.dart';

import 'package:mobile_app/screens/Dashborad_User/Login+Regsiter/signin_page.dart';

import 'package:http/http.dart' as http;
import 'package:mobile_app/widgets/Alert_Box.dart';
import 'package:mobile_app/widgets/my_password_field.dart';
import 'package:mobile_app/widgets/my_text_button.dart';
import 'dart:convert';

import 'package:mobile_app/widgets/my_text_field.dart';

class RegisterPageCompany extends StatefulWidget {
  @override
  _RegisterPageCompany createState() => _RegisterPageCompany();
}

class _RegisterPageCompany extends State<RegisterPageCompany> {
  bool passwordVisibility = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future<String> RegisterCompany(var email, var name, var password) async {
    String url = name_domain_server + "register/company";
    print(email);
    print(password);
    print(name);
    var res = await http.post(
      Uri.parse('$url'),
      body: {'email': email, 'name': name, 'password': password},
    );
    print(res.statusCode);
    if (res.statusCode == 200) {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      String message = parsedJson['message'];
      return message;
    } else {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      String error = parsedJson['error'];
      return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blueGrey,
        backgroundColor: const Color.fromARGB(255, 13, 29, 37),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
            width: 24,
            // color: Colors.white,
            image: Svg('assets/images/back_arrow.svg'),
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Register",
                            style: kHeadline,
                          ),
                          Text(
                            "Create new account to get started.",
                            style: kBodyText2,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          MyTextField(
                            TextController: nameController,
                            hintText: 'Name',
                            inputType: TextInputType.name,
                          ),
                          MyTextField(
                            TextController: emailController,
                            hintText: 'Email',
                            inputType: TextInputType.emailAddress,
                          ),
                          MyPasswordField(
                            passwordController: passwordController,
                            isPasswordVisible: passwordVisibility,
                            onTap: () {
                              setState(() {
                                passwordVisibility = !passwordVisibility;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    MyTextButton(
                      buttonName: 'Register',
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) => Center(
                                  child: CircularProgressIndicator(),
                                ));
                        var message = await RegisterCompany(
                            emailController.text,
                            nameController.text,
                            passwordController.text);
                        print('the res is $message');
                        if (message == "company Created ") {
                          // showAlertDialog(context, message as String);
                          // Navigator.of(context).pop();
                        } else {
                          // showAlertDialog(context, message as String);
                          Navigator.of(context).pop();
                          // Navigator.of(context).pop();
                        }
                      },
                      bgColor: const Color.fromARGB(255, 13, 29, 37),
                      textColor: Colors.white,
                    )
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
