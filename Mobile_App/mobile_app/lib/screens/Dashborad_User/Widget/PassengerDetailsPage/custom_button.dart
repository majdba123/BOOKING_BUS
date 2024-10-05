import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Breack_place.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Pill_Card_spsecfication/Book_Card_Resvartion_spsecfication.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/payment/PaymentDetails.dart';
import 'package:mobile_app/widgets/CustomeCirculerProgress.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/break_point.dart';
import 'onboarding_overlay.dart';

class PassengerDetailsPage extends StatefulWidget {
  @override
  _PassengerDetailsPageState createState() => _PassengerDetailsPageState();
}

class _PassengerDetailsPageState extends State<PassengerDetailsPage> {
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
    final busProvider = Provider.of<BussofSpsccifTripProvider>(context);
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
            double sectionTitleSize = isLargeScreen ? 20 : 18;
            double buttonWidth = isLargeScreen ? 200 : 150;
            double buttonHeight = isLargeScreen ? 60 : 50;

            return Stack(
              children: [
                backImage(context),
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
                                'Boarding points:',
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
                                              ? '🚌 ${selectedBoardingPoint!.nameBreak} '
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
                              PaymentDetails(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 40.0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            onPressed: () async {
                              var accessToken = Provider.of<AuthProvider>(
                                      context,
                                      listen: false)
                                  .accessToken;

                              final provider = Provider.of<TripuserProvider>(
                                  context,
                                  listen: false);

                              try {
                                await provider.make_reservation(
                                    accessToken,
                                    busProvider.selectedTypeTripIndex == 0
                                        ? 1
                                        : 2,
                                    busProvider.selectedSeat,
                                    busProvider.selectedBoardingPoint!.breakId,
                                    busProvider
                                        .busResponses[busProvider
                                            .selectIndexOfSpsecifcBustrip]
                                        .bus_trip_id);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TripTicketPage(),
                                  ),
                                );
                              } catch (e) {
                                if (e
                                    .toString()
                                    .contains('Seat already booking')) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content: Text('Seat already booking'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DashboardUser()),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content: Text(e.toString()),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DashboardUser()),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }

                              // makeReservation(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[400],
                              padding: EdgeInsets.zero,
                              textStyle: TextStyle(fontSize: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Consumer<TripuserProvider>(
                                builder: (context, provider, child) {
                              if (provider.isLoading) {
                                return CustomeProgressIndecator(context);
                              } else {
                                return Container(
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Continue to pay',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }
                            }),
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
