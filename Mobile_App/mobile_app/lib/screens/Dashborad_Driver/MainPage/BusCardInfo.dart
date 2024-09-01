import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/Driver/MyBusModel.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/WidgetApp/WaveCliper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyBusInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(builder: (context, provider, child) {
      // Handle loading state
      if (provider.isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (provider.errorMessage != null) {
        return Center(
          child: Text('Error: ${provider.errorMessage}'),
        );
      }
      MyBusModel? busmodel = provider.MyBus;
      if (busmodel == null) {
        return Center(
          child: Text('No bus available'),
        );
      }
      return Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // SizedBox(width: 10),
                    Icon(Icons.directions_bus_filled_sharp,
                        size: 28, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'My Bus Info',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 20),
                // Text(
                //   busmodel.id,
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Colors.white70,
                //   ),
                // ),
                SizedBox(height: 20),
                Text(
                  ' ${busmodel.company_name}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),

                SizedBox(height: 15),
                Text(
                  'S.N: ${busmodel.number_passenger}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ClipPath(
                clipper: WaveClipper(),
                child: SvgPicture.asset(
                  "assets/images/logoBT.svg",
                  fit: BoxFit.cover,
                  color: Colors.white,
                  width: double.infinity,
                  height: 200, // Adjust height as needed
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
