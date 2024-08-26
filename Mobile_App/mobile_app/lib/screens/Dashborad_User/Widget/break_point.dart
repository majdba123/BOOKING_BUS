import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/Breack_place.dart';
import 'package:mobile_app/Data_Models/Trip_by_Path.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:provider/provider.dart';

class PointsPage extends StatefulWidget {
  final Function(BreakPlace) onBoardingPointSelected;
  final Function(BreakPlace) onDeboardingPointSelected;

  PointsPage({
    required this.onBoardingPointSelected,
    required this.onDeboardingPointSelected,
  });

  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Use white background as in the UI image
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<TripuserProvider>(
          builder: (context, busProvider, child) {
            List<BreakPlace>? breaks;
            if (busProvider.selectedBus != null) {
              breaks = busProvider.selectedBus!.breaks;
            } else if (busProvider.selectedBusTrip != null) {
              breaks = busProvider.selectedBusTrip!.breaks;
            }

            // Remove the last item from the boarding and deboarding points
            List<BreakPlace> boardingPoints =
                breaks != null && breaks.length > 1
                    ? breaks.sublist(0, breaks.length - 1)
                    : [];
            List<BreakPlace> deboardingPoints =
                breaks != null && breaks.length > 1 ? breaks.sublist(1) : [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30), // Margin from top
                Row(
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: AppColors.primaryColor),
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
                    SizedBox(
                        width: 48), // To balance the arrow button on the left
                  ],
                ),
                SizedBox(height: 20),
                if (boardingPoints.isNotEmpty) ...[
                  Text(
                    'Boarding points:',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Column(
                    children: boardingPoints.map((point) {
                      return RadioListTile<BreakPlace>(
                        title: Text(
                          '${point.nameBreak} @ 13:50', // Assume `eventTime` contains the time string
                          style: TextStyle(fontSize: 16),
                        ),
                        value: point,
                        groupValue: busProvider.selectedBoardingPoint,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) {
                          if (value != null) {
                            widget.onBoardingPointSelected(
                                value); // Update the callback
                            busProvider.selectBoardingPoint(value);
                            busProvider
                                .selectBordingBreakPlcaeId(value.breakId);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
                SizedBox(height: 20),
                if (deboardingPoints.isNotEmpty) ...[
                  Text(
                    'Deboarding points:',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Column(
                    children: deboardingPoints.map((point) {
                      return RadioListTile<BreakPlace>(
                        title: Text(
                          '${point.nameBreak} @ 15:30', // Assume `eventTime` contains the time string
                          style: TextStyle(fontSize: 16),
                        ),
                        value: point,
                        groupValue: busProvider.selectedDeboardingPoint,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) {
                          if (value != null) {
                            widget.onDeboardingPointSelected(
                                value); // Update the callback
                            busProvider.selectDeboardingPoint(value);
                            busProvider
                                .selectdeBordingBreakPlcaeId(value.breakId);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ] else ...[
                  Center(
                    child: Text(
                      'No breaks available',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
                Spacer(),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
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
