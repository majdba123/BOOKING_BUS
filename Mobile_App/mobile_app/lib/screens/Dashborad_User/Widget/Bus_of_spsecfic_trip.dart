import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/SeatsGridPage.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Colors.dart';

class BusCardofSpecicTrip extends StatefulWidget {
  final int tripId;
  final String companyName;
  BusCardofSpecicTrip({required this.tripId, required this.companyName});

  @override
  _BusCardofSpecicTripState createState() =>
      _BusCardofSpecicTripState(tripId: tripId, companyName: companyName);
}

class _BusCardofSpecicTripState extends State<BusCardofSpecicTrip> {
  final int tripId;
  final String companyName;
  _BusCardofSpecicTripState({required this.tripId, required this.companyName});

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<BussofSpsccifTripProvider>(context, listen: false);
    final authprovider = Provider.of<AuthProvider>(context, listen: false);
    provider.getBussofSpecicTrip(tripId, authprovider.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          child: Consumer<BussofSpsccifTripProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading || provider.busResponses.isEmpty) {
                return const Text('Loading...');
              }

              final busTrip = provider.busResponses.first;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          busTrip.from,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.directions_bus,
                          color: Colors.white,
                          size: 28.0,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          busTrip.to,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      'Available Bus Trips',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer<BussofSpsccifTripProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final busTrips = provider.busResponses;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: busTrips.length,
            itemBuilder: (context, index) {
              final busTrip = busTrips[index];

              return Card(
                margin: EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 3,
                child: InkWell(
                  onTap: () {
                    // Navigate to seat selection screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SeatsGridPage(
                          companyName: companyName,
                          from: busTrip.from,
                          to: busTrip.to,
                          fromTime: busTrip.fromTime,
                          toTime: busTrip.toTime,
                          seats: busTrip.seats,
                        ),
                      ),
                    );
                  },
                  splashColor: AppColors.primaryColor.withOpacity(0.1),
                  highlightColor: Colors.grey.withOpacity(0.1),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/logo_bus.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    busTrip.type,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Event: ${busTrip.event}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text('Bus No: ${busTrip.busId}',
                                  style: TextStyle(color: Colors.green[800])),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTimeLocationColumn(
                                busTrip.fromTime, busTrip.from, context),
                            Icon(Icons.directions_bus,
                                color: Colors.grey, size: 24.0),
                            _buildTimeLocationColumn(
                                busTrip.toTime, busTrip.to, context),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Divider(
                          height: 32.0,
                          thickness: 1.5,
                          color: Colors.grey[300],
                        ),
                        _buildBreakStopTimeline(busTrip),
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 4.0),
                            Text('Rating: 4.4',
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 14.0)),
                            Spacer(),
                            Row(
                              children: [
                                Icon(Icons.person, size: 20),
                                SizedBox(width: 4.0),
                                Text('${busTrip.seats.length} Seats',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14.0)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBreakStopTimeline(busTrip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Break Stops',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 10.0),
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final segmentWidth = totalWidth / busTrip.breaks.length;
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned(
                  left: segmentWidth / 2,
                  right: segmentWidth / 2,
                  child: CustomPaint(
                    size: Size(
                      totalWidth - segmentWidth,
                      10.0,
                    ),
                    painter: RoadPathPainter(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: busTrip.breaks.map<Widget>((breakPlace) {
                    return Container(
                      width: segmentWidth,
                      child: Column(
                        children: [
                          Text(
                            '40',
                            // breakPlace.time, // Time of the stop
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Icon(
                            Icons.location_on,
                            color: AppColors.primaryColor,
                            size: 20.0,
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            breakPlace.nameBreak, // Name of the stop
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Column _buildTimeLocationColumn(
      String time, String location, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          location,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}

class RoadPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    double dashWidth = 6.0;
    double dashSpace = 4.0;
    double startX = 0.0;

    // Draw dashed line only between the first and last points
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
