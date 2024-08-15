import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Payment_page.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/break_point.dart';
import 'package:provider/provider.dart';

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
  @override
  // void initState() {
  //   final busProvider = Provider.of<TripuserProvider>(context);
  //   busProvider.calculatePrice(
  //       busProvider.selectedSeat!.length, busProvider.price_tiket);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final busProvider = Provider.of<TripuserProvider>(context);
    // print(busProvider.selectedBus?.breaks);
    // print(busProvider.selectedSeat);
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double horizontalPadding = constraints.maxWidth > 600 ? 60.0 : 16.0;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30), // Margin from top
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.black),
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
                            fontSize: 19,
                            // fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '🚌 ${busProvider.from}',
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    '🚌 ${busProvider.to}',
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PointsPage()),
                                  );
                                },
                                child: Text('Change'),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey[300],
                                  foregroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Passenger details:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
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
                              labelStyle:
                                  TextStyle(color: AppColors.primaryColor),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Age',
                              style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 100.0),
                              child: Text(
                                'Gender',
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: TextField(
                                    controller: _ageController,
                                    decoration: InputDecoration(
                                      labelText: 'Age',
                                      labelStyle: TextStyle(
                                          color: AppColors.primaryColor),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
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
                                    Text('Male',
                                        style: TextStyle(
                                            color: AppColors.primaryColor)),
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
                                    Text('Female',
                                        style: TextStyle(
                                            color: AppColors.primaryColor)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Contact details:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'E-mail',
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.white,
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              labelStyle:
                                  TextStyle(color: AppColors.primaryColor),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Phone Number',
                          style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor),
                        ),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.white,
                          child: TextField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle:
                                  TextStyle(color: AppColors.primaryColor),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
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
                            Text(
                              'Send mail and message about the trip details?',
                              style: TextStyle(color: AppColors.primaryColor),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor),
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
                        padding: EdgeInsets.zero, // Remove default padding
                        textStyle: TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Container(
                        width: 150, // Set the width you want
                        height: 50, // Set the height you want
                        alignment: Alignment.center, // Center the text
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
          );
        },
      ),
    );
  }
}
