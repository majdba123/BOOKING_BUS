import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

class StopDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: Icon(Icons.arrow_back, size: screenHeight * 0.03),
        title: Text(
          'Stop Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenHeight * 0.025,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * 0.02),
            // Journey Information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coimbatore to Chennai',
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      '48 Passengers · 28 Stops',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenHeight * 0.018,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.025,
                    vertical: screenHeight * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 233, 222),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'IN 4 HOURS',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: screenHeight * 0.015,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),

            // Stop Title and Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stop 1 - Kanchipuram',
                  style: TextStyle(
                    fontSize: screenHeight * 0.022,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: screenHeight * 0.03,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),

            // Stop Information Box
            Container(
              padding: EdgeInsets.all(screenHeight * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Information Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.people,
                          color: Colors.grey, size: screenHeight * 0.022),
                      SizedBox(width: screenWidth * 0.015),
                      Text(
                        '12',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.018,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.015),
                      Icon(Icons.compare_arrows,
                          color: Colors.grey, size: screenHeight * 0.022),
                      SizedBox(width: screenWidth * 0.015),
                      Text(
                        '5',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.018,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.015),
                      Icon(Icons.arrow_upward,
                          color: Colors.green, size: screenHeight * 0.022),
                      SizedBox(width: screenWidth * 0.015),
                      Icon(Icons.arrow_downward,
                          color: Colors.red, size: screenHeight * 0.022),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Passenger List
                  Column(
                    children: [
                      buildPassengerRow(
                        icon: Icons.arrow_upward,
                        color: Colors.green,
                        id: 'UL11',
                        name: 'Vignesh',
                        age: 24,
                        gender: 'Male',
                        context: context,
                      ),
                      buildPassengerRow(
                        icon: Icons.arrow_downward,
                        color: Colors.red,
                        id: 'UL12',
                        name: 'Zashria',
                        age: 22,
                        gender: 'Female',
                        context: context,
                      ),
                      buildPassengerRow(
                        icon: Icons.arrow_upward,
                        color: Colors.green,
                        id: 'UL13',
                        name: 'Adlin',
                        age: 22,
                        gender: 'Female',
                        context: context,
                      ),
                      buildPassengerRow(
                        icon: Icons.arrow_upward,
                        color: Colors.green,
                        id: 'UL14',
                        name: 'Ashley',
                        age: 22,
                        gender: 'Female',
                        context: context,
                      ),
                      buildPassengerRow(
                        icon: Icons.arrow_upward,
                        color: Colors.green,
                        id: 'UL15',
                        name: 'Zashria',
                        age: 22,
                        gender: 'Female',
                        context: context,
                      ),
                      buildPassengerRow(
                        icon: Icons.arrow_upward,
                        color: Colors.green,
                        id: 'UL16',
                        name: 'Zashria',
                        age: 22,
                        gender: 'Female',
                        context: context,
                      ),
                      // Repeat the same or add more passengers as needed
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),

            // Back to Journey Button
            Padding(
              padding: EdgeInsets.only(
                bottom: screenHeight * 0.02,
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                  ),
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Back to Journey',
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Passenger Row Widget
  Widget buildPassengerRow({
    required IconData icon,
    required Color color,
    required String id,
    required String name,
    required int age,
    required String gender,
    required BuildContext context,
  }) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
      child: Row(
        children: [
          Icon(icon, color: color, size: screenHeight * 0.022),
          SizedBox(width: screenWidth * 0.02),
          Text(
            id,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenHeight * 0.018,
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Text(
            '- $name ${age.toString()} $gender',
            style: TextStyle(
              fontSize: screenHeight * 0.018,
            ),
          ),
        ],
      ),
    );
  }
}
