import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/Trip_by_Path.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:provider/provider.dart';

class PointsPage extends StatefulWidget {
  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<TripuserProvider>(
          builder: (context, busProvider, child) {
            return Column(
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
                ...busProvider.selectedBus!.breaks.map((point) {
                  return RadioListTile<BreakPlace>(
                    title: Text(point.nameBreak),
                    value: point,
                    groupValue: busProvider.selectedBoardingPoint,
                    onChanged: (value) {
                      if (value != null) {
                        busProvider.selectBoardingPoint(value);
                        busProvider.selectBordingBreakPlcaeId(value.breakId);
                      }
                    },
                  );
                }).toList(),
                SizedBox(height: 20),
                Text(
                  'Deboarding points:',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                ...busProvider.selectedBus!.breaks.map((point) {
                  return RadioListTile<BreakPlace>(
                    title: Text(point.nameBreak),
                    value: point,
                    groupValue: busProvider.selectedDeboardingPoint,
                    onChanged: (value) {
                      if (value != null) {
                        busProvider.selectDeboardingPoint(value);
                        busProvider.selectdeBordingBreakPlcaeId(value.breakId);
                      }
                    },
                  );
                }).toList(),
                Spacer(),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF083B4C),
                      padding: EdgeInsets.zero,
                      textStyle: TextStyle(fontSize: 16, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Container(
                      width: 200,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text('Proceed',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
