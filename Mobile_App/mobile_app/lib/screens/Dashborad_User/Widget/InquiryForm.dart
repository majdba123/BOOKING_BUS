import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/inquiry_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Profile_User.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/PositionedMessage.dart';

class InquiryForm extends StatefulWidget {
  @override
  State<InquiryForm> createState() => _InquiryFormState();
}

class _InquiryFormState extends State<InquiryForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();

  @override
  void initState() {
    Provider.of<InquiryProvider>(context, listen: false).clearMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InquiryProvider>(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Send Inquiry'),
        backgroundColor: Colors.grey[200],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.05,
                vertical: screenSize.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.04,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your email',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Text(
                          'Question',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.04,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        TextFormField(
                          controller: _questionController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your question',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your question';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                provider
                                    .sendInquiry(
                                  _emailController.text,
                                  _questionController.text,
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .accessToken,
                                )
                                    .then((_) {
                                  if (provider.successMessage != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: PositionedMessage(
                                          message: provider.successMessage!,
                                          icon: Icons.check,
                                          color: Colors.green,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ),
                                    );
                                    Future.delayed(Duration(milliseconds: 5),
                                        () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()),
                                      );
                                    });
                                  }
                                });
                              }
                            },
                            child: provider.isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontSize: screenSize.width * 0.04,
                                        color: Colors.white),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.02,
                              ),
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (provider.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              provider.errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: screenSize.width * 0.04,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: screenSize.height * 0.05),
                      width: screenSize.width * 0.8,
                      height: screenSize.height * 0.3,
                      child: Image.asset(
                        'assets/support.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
