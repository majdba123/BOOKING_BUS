import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_Driver/MainPage/Dashbord.dart';
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
      return;
    }

    bool isProfileComplete = await prefsHelper.isUserIdInList(userId);

    if (isProfileComplete) {
      _navigateToDashboard();
    } else {
      try {
        var userProvider =
            Provider.of<UserInfoProvider>(context, listen: false);
        await userProvider.fetchUserInfo(accessToken!, authprovider.userType);
        var userInfo = userProvider.userInfo;
        print('the use info is ! $userInfo');
        if (userInfo?.profile_image == null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CompleteProfilePage(),
            ),
          );
        } else {
          print('try to svae the profile use!!');
          await prefsHelper.saveUserIdList([userId]);
          print('try to go to dash boder!!!');
          _navigateToDashboard();
        }
      } catch (error) {
        print('Error fetching user info: $error');
      }
    }
  }

  void _navigateToDashboard() {
    if (mounted) {
      setState(() {
        _isChecking = false;
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
              ? Center(
                  child: SizedBox(
                  height: 60.0,
                  width: 60.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                    color: AppColors.primaryColor,
                  ),
                ))
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
