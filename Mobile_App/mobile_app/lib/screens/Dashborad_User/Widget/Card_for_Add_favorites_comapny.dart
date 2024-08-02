import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

class CardfavoriteCompany extends StatelessWidget {
  final String name_of_company;
  final String image_link;

  const CardfavoriteCompany({
    required this.name_of_company,
    required this.image_link,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize =
        screenWidth * 0.04; // Adjust the scale factor as needed
    double subtitleFontSize =
        screenWidth * 0.035; // Adjust the scale factor as needed
    // print('the trip id is $tripId');
    return Container(
      margin: EdgeInsets.only(right: 8.0),
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
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(
                    'https://t3.ftcdn.net/jpg/02/51/59/46/360_F_251594672_c7xertPrElSFJ5eTd6V0CmQE1CyGC6Ke.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name_of_company,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
