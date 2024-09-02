import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mobile_app/Provider/Admin/charge_blanace_requsert_provider.dart';
import 'package:mobile_app/Provider/Company/Private_Trip_provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
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
import 'package:mobile_app/screens/Dashborad_Driver/JourneyPage/journeys_screen.dart';
import 'package:mobile_app/screens/Dashborad_Driver/MainPage/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/MyBooking/MY_Reservation.dart';
import 'package:mobile_app/screens/Dashborad_User/Profile/Profile_User.dart';
import 'package:mobile_app/screens/Dashborad_User/Pusher_Client/Pusher_Client.dart';
import 'package:mobile_app/Provider/user/user_info_profile.dart';
import 'package:mobile_app/screens/Dashborad_User/firstPageInApplication/welcome_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PusherService(); // Initialize PusherService
  runApp(
    KeyboardDismissOnTap(
      child: MultiProvider(
        providers: [
          // ChangeNotifierProvider(create: (_) => PathProvider()),
          // ChangeNotifierProvider(
          //     create: (BuildContext context) => BusProvider()),
          ChangeNotifierProvider(create: (_) => DriverProvider()),
          // ChangeNotifierProvider(create: (_) => SeatProvider()),
          // ChangeNotifierProvider(create: (_) => areaProvider()),
          // ChangeNotifierProvider(create: (_) => BreakAreaProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          // ChangeNotifierProvider(create: (_) => BusStatusProvider()),
          // ChangeNotifierProvider(create: (_) => AssingBusProvider()),
          // ChangeNotifierProvider(create: (_) => TripBusProvider()),
          // ChangeNotifierProvider(create: (_) => TripBusStatusProvider()),
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
          ChangeNotifierProvider(create: (_) => DriverProvider()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    // KeyboardVisibilityService keyboardVisibilityService =
    //     KeyboardVisibilityService(context);

    return MaterialApp(
        routes: {
          // '/BusDash': (context) => Bus_management_Page(),
          '/mainPageUser': (context) => DashboardUser(),
          '/driverPageUser': (context) => DashboardDriver(),
          '/JourneysScreen': (context) => JourneysScreen(),
          '/BookingUser': (context) => BookingsScreen(),

          '/ProfilePage': (context) => ProfilePage(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Inter'),
        home: WelcomePage()

        //  ,
        );
  }
}
