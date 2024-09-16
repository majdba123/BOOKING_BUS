import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/WidgetApp/filtter_Bar_main_ui.dart';
import 'package:provider/provider.dart';
import 'JourneyCard.dart';
import 'JourneyHistoryScreen.dart';
import 'package:toggle_switch/toggle_switch.dart';

class JourneysScreen extends StatefulWidget {
  @override
  _JourneysScreenState createState() => _JourneysScreenState();
}

class _JourneysScreenState extends State<JourneysScreen> {
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
      var driverProvider = Provider.of<DriverProvider>(context, listen: false);
      auth = Provider.of<AuthProvider>(context, listen: false);
      driverProvider.fetchMyTrip(auth.accessToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var driverProvider = Provider.of<DriverProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Your Trip',
          style: TextStyle(
            fontSize: screenHeight * 0.03,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AuthProvider auth =
                        Provider.of<AuthProvider>(context, listen: false);

                    driverProvider.history(auth.accessToken);
                    driverProvider.setypePage('history');
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JourneyHistoryScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.12,
                    vertical: screenHeight * 0.015,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'History',
                  style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            ToggleSwitch(
              minWidth: 180.0,
              initialLabelIndex: driverProvider.selectedTypeTripIndex,
              cornerRadius: 20.0,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              totalSwitches: 2,
              labels: ['Going', 'Outgoing'],
              icons: [Icons.arrow_forward_outlined, Icons.arrow_back],
              activeBgColors: [
                [AppColors.primaryColor],
                [AppColors.primaryColor]
              ],
              onToggle: (index) {
                print(index);
                print('select tooggle ');
                driverProvider.setTypeTripIndex(index!);
              },
            ),
            // SectionHeader(
            //   title: 'Today',
            //   fontSize: screenHeight * 0.025,
            // ),

            SizedBox(height: screenHeight * 0.015),
            Expanded(
                child: ListView(
              children: [
                if (driverProvider.selectedTypeTripIndex == 0)
                  JourneyCard(), // Show Going Trip content
                if (driverProvider.selectedTypeTripIndex == 1)
                  JourneyCard(), // Show Outgoing Trip content
              ],
            )),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenHeight * 0.01,
        ),
        child: FilterBarUserUi(
          height: screenHeight * 0.07,
          iconSize: screenHeight * 0.03,
        ),
      ),
    );
  }
}
