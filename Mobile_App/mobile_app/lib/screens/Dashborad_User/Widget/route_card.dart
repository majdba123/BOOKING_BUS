import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_of_spsecfic_trip.dart';

class RouteCard extends StatelessWidget {
  final String from;
  final String to;
  final String price;
  final int tripId;
  final String companyName;
  final String imageUrl;

  const RouteCard({
    required this.tripId,
    required this.from,
    required this.to,
    required this.price,
    required this.companyName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.85;
    double cardHeight =
        100.0; // Adjusted height to accommodate the company name
    double titleFontSize = 16.0;
    double subtitleFontSize = 12.0;
    double companyFontSize = 11.0; // Font size for the company name
    double imageWidth = 80.0;
    double imageHeight = 80.0;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BusCardofSpecicTrip(
              companyName: companyName,
              tripId: tripId,
            ),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 240, 237, 237), // Adding transparency
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: imageWidth,
              height: imageHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 4.0),
                  Text(
                    '$from → $to',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                      color: AppColors.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    companyName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: companyFontSize,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'from $price \$',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: subtitleFontSize,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
