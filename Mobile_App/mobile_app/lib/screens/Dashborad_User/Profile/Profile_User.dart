import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_Driver/MainPage/BusCardInfo.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/PrivateTrip/Get_private_trip_By_Status.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Help_Screen.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Rate_Driver.dart';
import 'package:mobile_app/Provider/user/user_info_profile.dart';
import 'package:mobile_app/screens/Dashborad_User/policy/PolicyPage.dart';
import 'package:mobile_app/screens/WidgetApp/E_wallet.dart';
import 'package:mobile_app/screens/WidgetApp/ProfileOption.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/colors.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Address_list_page.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Update_Password.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Update_Profile.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    var accessToken = authProvider.accessToken;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    // Fetch user info when the widget is built
    Provider.of<UserInfoProvider>(context, listen: false)
        .fetchUserInfo(accessToken, authProvider.userType);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => DashboardUser(),
              ),
              result: ModalRoute.withName('/mainPageUser'),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<UserInfoProvider>(
            builder: (context, userInfoProvider, child) {
              if (userInfoProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (userInfoProvider.errorMessage != null) {
                return Center(child: Text(userInfoProvider.errorMessage!));
              } else if (userInfoProvider.userInfo != null) {
                final userInfo = userInfoProvider.userInfo!;

                return Stack(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth,
                      height: screenHeight,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/background_mappp.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(userInfo.profile_image!),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  userInfo.name,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  userInfo.email,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  userInfo.phoneNumber!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ProfileOption(
                          icon: Icons.location_on,
                          title: 'My Address',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddressListPage()),
                            );
                          },
                        ),
                        ProfileOption(
                          icon: Icons.password,
                          title: 'Password Settings',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdatePasswordPage()),
                            );
                          },
                        ),
                        ProfileOption(
                          icon: Icons.person,
                          title: 'Update Profile',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateProfilePage()), // Navigate to UpdateProfilePage
                            );
                          },
                        ),
                        if (authProvider.userType == "user") ...[
                          ProfileOption(
                            icon: Icons.calendar_month,
                            title: ' private Trip',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PrivateTripByStatus()),
                              );
                            },
                          ),
                          SizedBox(height: 5),
                          ProfileOption(
                            icon: Icons.rate_review,
                            title: 'Rating Driver',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RatingDriverUi()),
                              );
                            },
                          ),
                          SizedBox(height: 5),
                          ProfileOption(
                            icon: Icons.question_answer,
                            title: 'send Qustion',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HelpDeskScreen()),
                              );
                            },
                          ),
                          SizedBox(height: 5),
                          ProfileOption(
                            icon: Icons.question_answer,
                            title: 'Policy of use',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PolicyPage()),
                              );
                            },
                          ),
                          SizedBox(height: 30),
                          EWalletSection()
                        ] else ...[
                          SizedBox(height: 30),
                          MyBusInfo(),
                        ],

                        // ,
                      ],
                    )
                  ],
                );
              } else {
                return Center(child: Text('No user information found.'));
              }
            },
          ),
        ),
      ),
    );
  }
}
