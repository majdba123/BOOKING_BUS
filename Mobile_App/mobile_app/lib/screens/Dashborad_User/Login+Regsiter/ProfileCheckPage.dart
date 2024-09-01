import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/Profile/Complete_info_profile.dart';
import 'package:mobile_app/Provider/user/user_info_profile.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:provider/provider.dart';
import 'shared_preferences_helper.dart';

class ProfileCheckPage extends StatefulWidget {
  @override
  _ProfileCheckPageState createState() => _ProfileCheckPageState();
}

class _ProfileCheckPageState extends State<ProfileCheckPage> {
  bool _isChecking = true;
  late AuthProvider authprovider;
  @override
  void initState() {
    super.initState();
    authprovider = Provider.of<AuthProvider>(context, listen: false);
    _checkProfileStatus();
  }

  var accessToken;
  Future<void> _checkProfileStatus() async {
    final prefsHelper = SharedPreferencesHelper();

    accessToken = authprovider.accessToken;
    print('the access token is !');
    print(accessToken);
    await Provider.of<UserInfoProvider>(context, listen: false)
        .fetchUserInfo(accessToken!, authprovider.userType);
    var userId =
        Provider.of<UserInfoProvider>(context, listen: false).userInfo?.id;
    print(userId);
    if (userId == null) {
      // If userId is null, handle the error (e.g., log out or show error)
      return;
    }

    bool isProfileComplete = await prefsHelper.isUserIdInList(userId);

    if (isProfileComplete) {
      // Profile is already marked complete, navigate to dashboard
      _navigateToDashboard();
    } else {
      // If profile status is not complete or not stored, fetch from server
      try {
        await Provider.of<UserInfoProvider>(context, listen: false)
            .fetchUserInfo(accessToken!, authprovider.userType);
        var userInfo =
            Provider.of<UserInfoProvider>(context, listen: false).userInfo;
        print('the use info is ! $userInfo');
        if (userInfo?.profile_image == null) {
          // If profile is not complete, navigate to the CompleteProfilePage
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CompleteProfilePage(),
            ),
          );
        } else {
          print('try to svae the profile use!!');
          await prefsHelper.saveUserIdList([userId]); // Update list
          print('try to go to dash boder!!!');
          _navigateToDashboard();
        }
      } catch (error) {
        // Handle error (e.g., show an error message or log out)
        print('Error fetching user info: $error');
      }
    }
  }

  void _navigateToDashboard() {
    if (mounted) {
      // Check if widget is still in the widget tree
      setState(() {
        _isChecking = false; // Update state to hide progress indicator
      });
      if (authprovider.userType == "user") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DashboardUser()),
        );
      } else if (authprovider.userType == "driver") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DashboardDriver()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backImage(context),
          _isChecking
              ? Center(child: CircularProgressIndicator())
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
