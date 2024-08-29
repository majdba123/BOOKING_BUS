import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/MyBooking/BookingCard.dart';
import 'package:mobile_app/screens/Dashborad_User/MyBooking/EmptyState.dart';
import 'package:mobile_app/screens/Dashborad_User/MyBooking/Filtter_button.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/TicketDetailsScreen.dart';
import 'package:provider/provider.dart';

class BookingsScreen extends StatefulWidget {
  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  void initState() {
    super.initState();
    final reservationProvider =
        Provider.of<TripuserProvider>(context, listen: false);
    var accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
    reservationProvider.fetchReservations('padding', accessToken);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final reservationProvider = Provider.of<TripuserProvider>(context);
    var accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Bookings',
          style: TextStyle(color: Colors.white, fontSize: 22.0),
        ),
        // backgroundColor: Colors.grey[200],
      ),
      body: Column(
        children: [
          // backImage(screenWidth, screenHeight),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterButton(
                  text: 'Active',
                  isSelected: reservationProvider.status == 'padding',
                  onPressed: () {
                    reservationProvider.fetchReservations(
                        'padding', accessToken);
                  },
                ),
                FilterButton(
                  text: 'Completed',
                  isSelected: reservationProvider.status == 'finished',
                  onPressed: () {
                    reservationProvider.fetchReservations(
                        'finished', accessToken);
                  },
                ),
                FilterButton(
                  text: 'Cancelled',
                  isSelected: reservationProvider.status == 'out',
                  onPressed: () {
                    reservationProvider.fetchReservations('out', accessToken);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: reservationProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : reservationProvider.errorMessage != null
                    ? Center(child: Text(reservationProvider.errorMessage!))
                    : reservationProvider.Myreservations.isEmpty
                        ? EmptyState()
                        : ListView.builder(
                            itemCount:
                                reservationProvider.Myreservations.length,
                            itemBuilder: (context, index) {
                              final reservation =
                                  reservationProvider.Myreservations[index];
                              return InkWell(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TicketDetailsScreen(
                                                  reservation: reservation))),
                                  child: BookingCard(reservation: reservation));
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
