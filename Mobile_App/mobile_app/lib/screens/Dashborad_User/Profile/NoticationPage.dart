import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/NotifcationProvider.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_Driver/MainPage/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';
import 'package:mobile_app/widgets/CustomeCirculerProgress.dart';
import 'package:provider/provider.dart';

class NotificationInboxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.read<NotificationProvider>();
    final auth = context.read<AuthProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationProvider.fetchNotifications(auth.accessToken);
    });

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              if (auth.userType == "user") {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DashboardUser()),
                );
              } else if (auth.userType == "driver") {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DashboardDriver()),
                );
              }
            },
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          title: Text(
            ' Notifications',
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          )),
      body: Stack(
        children: [
          backImage(context),
          Consumer<NotificationProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Center(child: CustomeProgressIndecator(context));
              }

              if (provider.errorMessage != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 40),
                      SizedBox(height: 16),
                      Text(provider.errorMessage!,
                          style: TextStyle(color: Colors.red)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            provider.fetchNotifications(auth.accessToken),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (provider.notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/images/no_result.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 30),
                      Text(
                        'No Notifcation found ...',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: provider.notifications.length,
                itemBuilder: (context, index) {
                  final notif = provider.notifications[index];
                  return Card(
                    color: Colors.grey[100],
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(Icons.notifications_active),
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        notif.notification,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('yyyy-MM-dd HH:mm').format(notif.created_at),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
