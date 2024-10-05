import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/Breack_place.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:mobile_app/constants.dart';
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
    var BusTrip =
        Provider.of<BussofSpsccifTripProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<BussofSpsccifTripProvider>(
          builder: (context, busProvider, child) {
            List<BreakPlace>? breaks;
            late List<BreakPlace> boardingPoints;
            breaks = BusTrip
                .busResponses[busProvider.selectIndexOfSpsecifcBustrip].breaks;
            if (busProvider.selectIndexOfSpsecifcBustrip == 0) {
              boardingPoints = breaks.sublist(0, breaks.length - 1);
            } else if (busProvider.selectIndexOfSpsecifcBustrip == 1) {
              boardingPoints =
                  breaks.sublist(0, breaks.length - 1).reversed.toList();
            }

            return Stack(
              children: [
                backImage(context),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: AppColors.primaryColor),
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
                        SizedBox(width: 48),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (boardingPoints.isNotEmpty) ...[
                      Text(
                        'Chosse A Boarding Point : ',
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
                              '${point.nameBreak} ',
                              style: TextStyle(fontSize: 16),
                            ),
                            value: point,
                            groupValue: BusTrip.selectedBoardingPoint,
                            activeColor: AppColors.primaryColor,
                            onChanged: (value) {
                              if (value != null) {
                                widget.onBoardingPointSelected(value);
                                BusTrip.selectBoardingPoint(value);
                                BusTrip.selectBordingBreakPlcaeId(
                                    value.breakId);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    SizedBox(height: 20),
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
                          textStyle:
                              TextStyle(fontSize: 16, color: Colors.white),
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
