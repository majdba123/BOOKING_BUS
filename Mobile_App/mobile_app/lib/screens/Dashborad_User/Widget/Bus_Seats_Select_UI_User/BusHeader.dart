import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/widget/buildDetailColumn.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/widget/buildIconWithText.dart';
import 'package:provider/provider.dart';

class BusHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerSpecificBusTrip =
        Provider.of<BussofSpsccifTripProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20.0,
        bottom: 15.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Column(
        children: [
          Text(
            providerSpecificBusTrip.companyName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildDetailColumn(Icons.place, providerSpecificBusTrip.from),
              buildDetailColumn(Icons.access_time,
                  'S : ${providerSpecificBusTrip.fromTime} - E : ${providerSpecificBusTrip.toTime}'),
              buildDetailColumn(Icons.place, providerSpecificBusTrip.to),
            ],
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIconWithText(Icons.access_time,
                  ' T :  ${providerSpecificBusTrip.Duration} H'),
              SizedBox(width: 12.0),
              buildIconWithText(Icons.linear_scale_sharp,
                  'D : ${providerSpecificBusTrip.Ditacnce}Km'),
            ],
          ),
        ],
      ),
    );
  }
}
