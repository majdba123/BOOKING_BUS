import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Complete_info_profile.dart';
import 'package:mobile_app/screens/Dashborad_User/user_info_profile.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/colors.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Address_list_page.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Charage_blance.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Update_Password.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Update_Profile.dart'; // Import the UpdateProfilePage
import 'package:mobile_app/Provider/Auth_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;

    // Fetch user info when the widget is built
    Provider.of<UserInfoProvider>(context, listen: false)
        .fetchUserInfo(accessToken);

    return Scaffold(
      appBar: AppBar(
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

                // Check if profile is incomplete
                if (userInfo.profile == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompleteProfilePage()),
                    );
                  });
                  return Container(); // Return empty container while navigating
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/images/user_avatar.jpg'),
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
                      userInfo.profile['phone'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
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
                      icon: Icons.favorite,
                      title: 'Fav Company',
                      onTap: () {
                        // Handle Privacy Settings
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
                    ProfileOption(
                      icon: Icons.help,
                      title: 'Help & Support',
                      onTap: () {
                        // Handle Help & Support
                      },
                    ),
                    SizedBox(height: 30),
                    EWalletSection(),
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

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  ProfileOption({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 28, color: AppColors.primaryColor),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class EWalletSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var point =
        Provider.of<UserInfoProvider>(context, listen: false).userInfo?.points;
    return Container(
      padding: EdgeInsets.all(16.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet, size: 28, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'E-Wallet',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Balance',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '\$ ${point}',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFundsPage()),
              );
            },
            child: Text(
              'Add Funds',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
