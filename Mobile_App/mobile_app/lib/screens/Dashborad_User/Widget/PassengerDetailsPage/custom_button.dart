import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/payment/payment_page.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/Trip_by_Path.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/break_point.dart';
import 'onboarding_overlay.dart';

class PassengerDetailsPage extends StatefulWidget {
  @override
  _PassengerDetailsPageState createState() => _PassengerDetailsPageState();
}

class _PassengerDetailsPageState extends State<PassengerDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _gender = 'Male';
  BreakPlace? selectedBoardingPoint;
  BreakPlace? selectedDeboardingPoint;

  bool _showOnboarding = true;
  int _currentStep = 1;

  void _nextStep() {
    setState(() {
      _currentStep++;
      if (_currentStep > 2) _showOnboarding = false;
    });
  }

  void _skipOnboarding() {
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final busProvider = Provider.of<TripuserProvider>(context);
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: GestureDetector(
        onTap: () {
          if (_showOnboarding) {
            _skipOnboarding();
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            double horizontalPadding = isLargeScreen ? 60.0 : 16.0;
            double inputFontSize = isLargeScreen ? 18 : 16;
            double labelFontSize = isLargeScreen ? 14 : 13;
            double sectionTitleSize = isLargeScreen ? 20 : 18;
            double buttonWidth = isLargeScreen ? 200 : 150;
            double buttonHeight = isLargeScreen ? 60 : 50;

            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back,
                                        color: AppColors.primaryColor),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Passenger Details',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Boarding and Deboarding points:',
                                style: TextStyle(
                                  fontSize: sectionTitleSize,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectedBoardingPoint != null
                                              ? '🚌 ${selectedBoardingPoint!.nameBreak} @ 5:50am'
                                              : '🚌 Not Selected',
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: inputFontSize,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          selectedDeboardingPoint != null
                                              ? '🚌 ${selectedDeboardingPoint!.nameBreak} @ 11:15am'
                                              : '🚌 Not Selected',
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: inputFontSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PointsPage(
                                              onBoardingPointSelected: (point) {
                                                setState(() {
                                                  selectedBoardingPoint = point;
                                                });
                                              },
                                              onDeboardingPointSelected:
                                                  (point) {
                                                setState(() {
                                                  selectedDeboardingPoint =
                                                      point;
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text('Change'),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        foregroundColor: AppColors.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              Text(
                                'Passenger details:',
                                style: TextStyle(
                                  fontSize: sectionTitleSize,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: labelFontSize,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                color: Colors.white,
                                child: TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    prefixIcon: Icon(Icons.person,
                                        color: AppColors.primaryColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  style: TextStyle(fontSize: inputFontSize),
                                ),
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Age',
                                    style: TextStyle(
                                      fontSize: labelFontSize,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 100.0),
                                    child: Text(
                                      'Gender',
                                      style: TextStyle(
                                        fontSize: labelFontSize,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Colors.white,
                                      child: TextField(
                                        controller: _ageController,
                                        decoration: InputDecoration(
                                          labelText: 'Age',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        style:
                                            TextStyle(fontSize: inputFontSize),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          activeColor: AppColors.primaryColor,
                                          value: 'Male',
                                          groupValue: _gender,
                                          onChanged: (value) {
                                            setState(() {
                                              _gender = value!;
                                            });
                                          },
                                        ),
                                        Text(
                                          'Male',
                                          style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: labelFontSize),
                                        ),
                                        Radio<String>(
                                          activeColor: AppColors.primaryColor,
                                          value: 'Female',
                                          groupValue: _gender,
                                          onChanged: (value) {
                                            setState(() {
                                              _gender = value!;
                                            });
                                          },
                                        ),
                                        Text(
                                          'Female',
                                          style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: labelFontSize),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Text(
                                'Contact details:',
                                style: TextStyle(
                                  fontSize: sectionTitleSize,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'E-mail',
                                style: TextStyle(
                                  fontSize: labelFontSize,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                color: Colors.white,
                                child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email,
                                        color: AppColors.primaryColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    labelText: 'E-mail',
                                    labelStyle: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(fontSize: inputFontSize),
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                  fontSize: labelFontSize,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                color: Colors.white,
                                child: TextField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.phone,
                                        color: AppColors.primaryColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    labelText: 'Phone Number',
                                    labelStyle: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(fontSize: inputFontSize),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Checkbox(
                                    value: true,
                                    onChanged: (value) {
                                      // Handle checkbox state change
                                    },
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Send mail and message about the trip details?',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: labelFontSize,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, -1),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Total\n£${busProvider.totoal_price}',
                            style: TextStyle(
                              fontSize: isLargeScreen ? 20 : 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[400],
                              padding: EdgeInsets.zero,
                              textStyle: TextStyle(fontSize: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Container(
                              width: buttonWidth,
                              height: buttonHeight,
                              alignment: Alignment.center,
                              child: Text(
                                'Continue to pay',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_showOnboarding)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showOnboarding = false;
                      });
                    },
                    child: OnboardingOverlay(
                      onNext: _nextStep,
                      onSkip: _skipOnboarding,
                      step: _currentStep,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
