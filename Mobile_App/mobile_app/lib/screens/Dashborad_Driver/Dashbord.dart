import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_Driver/JourneyPage/journeys_screen.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashboardDriver extends StatefulWidget {
  @override
  State<DashboardDriver> createState() => _DashboardDriverState();
}

class _DashboardDriverState extends State<DashboardDriver> {
  void _logout(BuildContext context) {
    // Implement logout functionality here
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 10),

                // Updated Header Section
                Container(
                  color: AppColors
                      .primaryColor, // Assuming AppColors.primaryColor is this color
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 25.0,
                    bottom: 25.0, // Add some padding at the bottom for spacing
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            right: 100.0), // Adjusted margin to match design
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Arrowspeed',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Driver Client',
                              style: TextStyle(
                                color: Colors
                                    .green, // Assuming this is the correct color
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.notifications_sharp,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.logout, color: Colors.white),
                            onPressed: () => _logout(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                Text(
                  'Good Evening Augustine!',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Here is your upcoming journey',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Color(0xFF9EDDCE)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chennai - Coimbatore',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '628 kms, 8.21 hrs',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        '42 Passengers • 28 Stops',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 12.0,
                                    color: Color(0xFF4267B2),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text('Chennai 10:30 pm',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[800],
                                      )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 20,
                                child: VerticalDivider(
                                  thickness: 2.0,
                                  color: Colors.grey[400],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 12.0,
                                    color: Color(0xFF27AE60),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text('Coimbatore 06:30 am',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[800],
                                      )),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '4',
                                style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4267B2),
                                ),
                              ),
                              Text(
                                'hours left',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Your Stats',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '£ 460.86',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF28A745),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Total Earnings',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '3.8',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Speed Rating',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '4.2',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Driving Rating',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            child: SfRadialGauge(
                              axes: <RadialAxis>[
                                RadialAxis(
                                  minimum: 0,
                                  maximum: 100,
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                      startValue: 0,
                                      endValue: 50,
                                      color: Colors.red,
                                      startWidth: 10,
                                      endWidth: 10,
                                    ),
                                    GaugeRange(
                                      startValue: 50,
                                      endValue: 75,
                                      color: Colors.orange,
                                      startWidth: 10,
                                      endWidth: 10,
                                    ),
                                    GaugeRange(
                                      startValue: 75,
                                      endValue: 100,
                                      color: Colors.green,
                                      startWidth: 10,
                                      endWidth: 10,
                                    ),
                                  ],
                                  pointers: <GaugePointer>[
                                    NeedlePointer(
                                      value: 78,
                                      needleColor: Colors.black,
                                      needleEndWidth: 5,
                                      lengthUnit: GaugeSizeUnit.factor,
                                      needleLength: 0.6,
                                    ),
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                      widget: Container(
                                        child: Text(
                                          '78%',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      angle: 90,
                                      positionFactor: 0.5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Driving Score',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.25),
              ],
            ),
          ),

          // Filter Bar Positioned at the Bottom
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: Color(0xFF003366),
                  borderRadius: BorderRadius.circular(40.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JourneysScreen()));
                      },
                      icon: Icon(Icons.home, color: Colors.white, size: 30),
                    ),
                    SizedBox(width: 50),
                    Icon(Icons.receipt, color: Colors.white, size: 30),
                    SizedBox(width: 50),
                    Icon(Icons.person, color: Colors.white, size: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
