import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Company/Bus_sataus.dart';
import 'package:mobile_app/Api_Services/Login_Api.dart';
import 'package:mobile_app/Provider/Admin/Area_Provider.dart';
import 'package:mobile_app/Provider/Admin/Break_Area_Provider.dart';
import 'package:mobile_app/Provider/Company/Assign_bus_provider.dart';
import 'package:mobile_app/Provider/Company/Bus_Provider.dart';
import 'package:mobile_app/Provider/Company/Driver_Provider.dart';
import 'package:mobile_app/Provider/Company/Seat_Provider.dart';
import 'package:mobile_app/Provider/Company/Trip_Provider.dart';
import 'package:mobile_app/Provider/Company/path_provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:mobile_app/screens/DashBorad_Company/Bus_managment/Bus_managment.dart';
import 'package:mobile_app/screens/DashBorad_Company/Dashbord.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Dashbord.dart';

import 'package:mobile_app/constants.dart';

import 'package:mobile_app/screens/welcome_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PathProvider()),
        ChangeNotifierProvider(create: (BuildContext context) => BusProvider()),
        ChangeNotifierProvider(create: (_) => DriverProvider()),
        ChangeNotifierProvider(create: (_) => SeatProvider()),
        ChangeNotifierProvider(create: (_) => areaProvider()),
        ChangeNotifierProvider(create: (_) => BreakAreaProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BusStatusProvider()),
        ChangeNotifierProvider(create: (_) => AssingBusProvider()),
        ChangeNotifierProvider(create: (_) => TripBusProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
    '/BusDash': (context) => Bus_management_Page(),
    // Other routes...
  },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Sign In Sign Up Ui',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: WelcomePage(),
    );
  }
}
