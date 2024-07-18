import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart'; // Assuming you have this import for colors

class PointsPage extends StatefulWidget {
  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  String _selectedBoardingPoint = 'Chennai CMBT @ 5:50am';
  String _selectedDeboardingPoint = 'Chennai CMBT @ 9:18am';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Points',
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
              'Boarding points:',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            RadioListTile(
              title: Text('Chennai CMBT @ 5:50am'),
              value: 'Chennai CMBT @ 5:50am',
              groupValue: _selectedBoardingPoint,
              onChanged: (value) {
                setState(() {
                  _selectedBoardingPoint = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Chennai CMBT @ 6:40am'),
              value: 'Chennai CMBT @ 6:40am',
              groupValue: _selectedBoardingPoint,
              onChanged: (value) {
                setState(() {
                  _selectedBoardingPoint = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Chennai CMBT @ 7:38am'),
              value: 'Chennai CMBT @ 7:38am',
              groupValue: _selectedBoardingPoint,
              onChanged: (value) {
                setState(() {
                  _selectedBoardingPoint = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Chennai CMBT @ 9:18am'),
              value: 'Chennai CMBT @ 9:18am',
              groupValue: _selectedBoardingPoint,
              onChanged: (value) {
                setState(() {
                  _selectedBoardingPoint = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Chennai CMBT @ 9:20am'),
              value: 'Chennai CMBT @ 9:20am',
              groupValue: _selectedBoardingPoint,
              onChanged: (value) {
                setState(() {
                  _selectedBoardingPoint = value.toString();
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Deboarding points:',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            RadioListTile(
              title: Text('Chennai CMBT @ 5:50am'),
              value: 'Chennai CMBT @ 5:50am',
              groupValue: _selectedDeboardingPoint,
              onChanged: (value) {
                setState(() {
                  _selectedDeboardingPoint = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Chennai CMBT @ 6:40am'),
              value: 'Chennai CMBT @ 6:40am',
              groupValue: _selectedDeboardingPoint,
              onChanged: (value) {
                setState(() {
                  _selectedDeboardingPoint = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Chennai CMBT @ 7:38am'),
              value: 'Chennai CMBT @ 7:38am',
              groupValue: _selectedDeboardingPoint,
              onChanged: (value) {
                setState(() {
                  _selectedDeboardingPoint = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Chennai CMBT @ 9:18am'),
              value: 'Chennai CMBT @ 9:18am',
              groupValue: _selectedDeboardingPoint,
              onChanged: (value) {
                setState(() {
                  _selectedDeboardingPoint = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Chennai CMBT @ 9:20am'),
              value: 'Chennai CMBT @ 9:20am',
              groupValue: _selectedDeboardingPoint,
              onChanged: (value) {
                setState(() {
                  _selectedDeboardingPoint = value.toString();
                });
              },
            ),
            Spacer(),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF083B4C), // Button background color
                  padding: EdgeInsets.zero, // Remove default padding
                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white), // Text style and color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
                child: Container(
                  width: 200, // Set the width you want
                  height: 50, // Set the height you want
                  alignment: Alignment.center, // Center the text
                  child: Text('Proceed',
                      style: TextStyle(color: Colors.white)), // Button text
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
