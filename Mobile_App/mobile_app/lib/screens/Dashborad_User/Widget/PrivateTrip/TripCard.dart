import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Private_Trip.dart';
import 'package:mobile_app/Provider/user/Accpeted_private_trip_By_company.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Trip_of_Specifc_Trip/Cloumn_Time_location.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/PrivateTrip/Map_in_private_trip.dart';

class TripCardPrivateTrip extends StatelessWidget {
  late PrivateTripModel privatetrip;
  TripCardPrivateTrip(this.privatetrip);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AcceptedPrivateTripByCompany(),
            ),
          );
        },
        splashColor: AppColors.primaryColor.withOpacity(0.1),
        highlightColor: Colors.grey.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    child: SvgPicture.asset(
                      "assets/images/logoBT.svg",
                      fit: BoxFit.contain,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Private Trip',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 8.0, vertical: 4.0),
                  //   decoration: BoxDecoration(
                  //     color: Colors.green[50],
                  //     borderRadius: BorderRadius.circular(8.0),
                  //   ),
                  //   child: Text(
                  //     'N. ${privatetrip.id ?? 'ID not available'}',
                  //     style: TextStyle(color: Colors.green[800]),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildTimeLocationColumn(
                      privatetrip.from ?? 'Time not available',
                      privatetrip.date ?? 'Date not available',
                      context),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/distance.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${privatetrip.Distance ?? 'Distance not available'}km',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  buildTimeLocationColumn(
                      privatetrip.to ?? 'Time not available',
                      privatetrip.time ?? 'Date not available',
                      context),
                ],
              ),
              const SizedBox(height: 15.0),
              Divider(
                height: 32.0,
                thickness: 1.5,
                color: Colors.grey[300],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MapPrivateTrip(
                      startLat: double.parse(privatetrip.lat_from),
                      startLng: double.parse(privatetrip.long_from),
                      destinationLat: double.parse(privatetrip.lat_to),
                      destinationLng: double.parse(privatetrip.long_to),
                    ),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 13,
                  ),
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Open in Map',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height * 0.018,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
