import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/CancelRuleOFcompay.dart';
import 'package:provider/provider.dart';

class CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        final userProvider =
            Provider.of<TripuserProvider>(context, listen: false);
        userProvider.fetchCanceltionRule(
            context.read<AuthProvider>().accessToken,
            userProvider.Myreservations[userProvider.specificIndexReservation]
                .company_name);
        showCancelRuleDialog(context);
      },
      icon: Icon(
        Icons.cancel,
        color: Colors.white,
      ),
      label: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          'Cancel Ticket',
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
