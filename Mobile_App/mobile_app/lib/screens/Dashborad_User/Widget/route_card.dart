import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_of_spsecfic_trip.dart';

class RouteCard extends StatelessWidget {
  final String from;
  final String to;
  final String price;
  final int tripId;
  final String companyName;
  final String imageUrl; // Add image URL for the photo

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
    double screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize = screenWidth * 0.05;
    double subtitleFontSize = screenWidth * 0.035;
    double priceFontSize = screenWidth * 0.04;
    double imageWidth = screenWidth * 0.22; // Responsive image width
    double imageHeight =
        screenWidth * 0.15; // Adjusted height for rectangular shape

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusCardofSpecicTrip(
              tripId: tripId,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
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
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$from →\n $to',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Text(
                  //   'Company: $companyName',
                  //   style: TextStyle(
                  //     fontSize: subtitleFontSize,
                  //     fontWeight: FontWeight.bold,
                  //     color: AppColors.primaryColor,
                  //   ),
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text(
                      //   'Trip ID: $tripId',
                      //   style: TextStyle(
                      //     fontSize: subtitleFontSize * 0.9,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      Chip(
                        label: Text(
                          '\$$price',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: priceFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: AppColors.primaryColor,
                      ),
                    ],
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
