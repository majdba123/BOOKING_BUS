import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/user/user_info_profile.dart';
import 'package:provider/provider.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    var infoUser = Provider.of<UserInfoProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Evening ${infoUser.userInfo?.name}',
          style: TextStyle(
            fontSize: screenHeight * 0.028,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          'Here is your upcoming journey',
          style: TextStyle(
            fontSize: screenHeight * 0.022,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
