import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:provider/provider.dart';

class JourneyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    var driverProvider = Provider.of<DriverProvider>(context, listen: false);
    var trip = driverProvider.MyTrip?[driverProvider.indextrip];

    return AppBar(
      backgroundColor: AppColors.primaryColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        '${trip?.from} to ${trip?.to}',
        style: TextStyle(
          color: Colors.white,
          fontSize: screenHeight * 0.025,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
