import 'package:flutter/material.dart';
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
  bool _isChecking = true; // Track whether profile check is in progress

  @override
  void initState() {
    super.initState();
    _checkProfileStatus();
  }

  Future<void> _checkProfileStatus() async {
    final prefsHelper = SharedPreferencesHelper();
    var accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
    print(accessToken);
    // print();
    // Fetch the user's unique identifier (e.g., userId or email)
    await Provider.of<UserInfoProvider>(context, listen: false)
        .fetchUserInfo(accessToken!);
    var userId =
        Provider.of<UserInfoProvider>(context, listen: false).userInfo?.id;
    print(userId);
    if (userId == null) {
      // If userId is null, handle the error (e.g., log out or show error)
      return;
    }

    bool isProfileComplete =
        await prefsHelper.isUserIdInList(userId.toString());

    if (isProfileComplete) {
      // Profile is already marked complete, navigate to dashboard
      _navigateToDashboard();
    } else {
      // If profile status is not complete or not stored, fetch from server
      try {
        await Provider.of<UserInfoProvider>(context, listen: false)
            .fetchUserInfo(accessToken!);
        var userInfo =
            Provider.of<UserInfoProvider>(context, listen: false).userInfo;

        if (userInfo?.profile_image == null) {
          // If profile is not complete, navigate to the CompleteProfilePage
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CompleteProfilePage(),
            ),
          );
        } else {
          // If profile is complete, store this status locally
          await prefsHelper.saveUserIdList([userId.toString()]); // Update list
          // Proceed to the main dashboard
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DashboardUser()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isChecking
          ? Center(child: CircularProgressIndicator())
          : SizedBox.shrink(), // Hide UI when checking is done
    );
  }
}
