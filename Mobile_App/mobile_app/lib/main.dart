import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Company/Bus_sataus.dart';
import 'package:mobile_app/Api_Services/Login_Api.dart';
import 'package:mobile_app/Provider/Admin/Area_Provider.dart';
import 'package:mobile_app/Provider/Admin/Break_Area_Provider.dart';
import 'package:mobile_app/Provider/Admin/charge_blanace_requsert_provider.dart';
import 'package:mobile_app/Provider/Company/Assign_bus_provider.dart';
import 'package:mobile_app/Provider/Company/Bus_Provider.dart';
import 'package:mobile_app/Provider/Company/Driver_Provider.dart';
import 'package:mobile_app/Provider/Company/Private_Trip_provider.dart';
import 'package:mobile_app/Provider/Company/Seat_Provider.dart';
import 'package:mobile_app/Provider/Company/Trip_Provider.dart';
import 'package:mobile_app/Provider/Company/Trip_Status.dart';
import 'package:mobile_app/Provider/Company/path_provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Address_provider.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:mobile_app/Provider/user/Company_Info.dart';
import 'package:mobile_app/Provider/user/Profile_provider.dart';
import 'package:mobile_app/Provider/user/Rating_Provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/Provider/user/Update_password_provider.dart';
import 'package:mobile_app/Provider/user/Wallet_provider.dart';
import 'package:mobile_app/Provider/user/inquiry_provider.dart';
import 'package:mobile_app/Provider/user/private_Trip_provider.dart';
import 'package:mobile_app/screens/DashBorad_Company/Bus_managment/Bus_managment.dart';
import 'package:mobile_app/screens/DashBorad_Company/Dashbord.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Dashbord.dart';

import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/JourneyDetailsScreen.dart';
import 'package:mobile_app/screens/Dashborad_User/Pusher_Client/Pusher_Client.dart';
import 'package:mobile_app/screens/Dashborad_User/Pusher_Client/Pusher_Client_Trip.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Book_Card_Resvartion_spsecfication.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_serach_selection.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Charage_blance.dart';
import 'package:mobile_app/screens/Dashborad_User/user_info_profile.dart';

import 'package:mobile_app/screens/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PusherService(); // Initialize PusherService
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
        ChangeNotifierProvider(create: (_) => TripBusProvider()),
        ChangeNotifierProvider(create: (_) => TripBusStatusProvider()),
        ChangeNotifierProvider(create: (_) => TripuserProvider()),
        ChangeNotifierProvider(create: (_) => PrivateTripuserProvider()),
        ChangeNotifierProvider(create: (_) => BussofSpsccifTripProvider()),
        ChangeNotifierProvider(create: (_) => WalletUserProvider()),
        ChangeNotifierProvider(create: (_) => ChargeRequestProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        ChangeNotifierProvider(create: (_) => updateProfileProvider()),
        ChangeNotifierProvider(create: (_) => UserInfoProvider()),
        ChangeNotifierProvider(create: (_) => PrivateTripProvider()),
        ChangeNotifierProvider(create: (_) => RatingUserProvider()),
        ChangeNotifierProvider(create: (_) => CompanyInfoProvider()),
        ChangeNotifierProvider(create: (_) => InquiryProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    return MaterialApp(
        routes: {
          '/BusDash': (context) => Bus_management_Page(),
          // Other routes...
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Sign In Sign Up Ui',
        theme: ThemeData(fontFamily: 'Inter'
            // scaffoldBackgroundColor:  AppColors.primaryColor,
            //  appBarTheme: AppBarTheme(
            //     // color: Color.fromARGB(255, 116, 136, 146),
            //   ),
            ),
        home: WelcomePage()

        //  ,
        );
  }
}
