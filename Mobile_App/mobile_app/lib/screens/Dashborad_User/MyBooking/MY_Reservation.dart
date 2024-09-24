import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/MyBooking/EmptyState.dart';
import 'package:mobile_app/screens/Dashborad_User/MyBooking/Filtter_button.dart';
import 'package:mobile_app/screens/Dashborad_User/MyBooking/Ticket_Trip.dart';
import 'package:mobile_app/screens/WidgetApp/AppBar.dart';
import 'package:mobile_app/widgets/CustomeCirculerProgress.dart';
import 'package:provider/provider.dart';

class BookingsScreen extends StatefulWidget {
  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  void initState() {
    final reservationProvider = context.read<TripuserProvider>();
    var accessToken = context.read<AuthProvider>().accessToken;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      reservationProvider.fetchReservations('padding', accessToken);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var accessToken = context.read<AuthProvider>().accessToken;

    final reservationProvider = Provider.of<TripuserProvider>(context);

    return Scaffold(
      appBar: customeAppBar(context, 'Bookings', null),
      body: Stack(
        children: [
          backImage(context),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FilterButton(
                      text: 'Active',
                      isSelected: reservationProvider.status == 'padding',
                      onPressed: () async {
                        await reservationProvider.fetchReservations(
                            'padding', accessToken);
                      },
                    ),
                    FilterButton(
                      text: 'Completed',
                      isSelected: reservationProvider.status == 'completed',
                      onPressed: () async {
                        await reservationProvider.fetchReservations(
                            'finished', accessToken);
                      },
                    ),
                    FilterButton(
                      text: 'Cancelled',
                      isSelected: reservationProvider.status == 'canceled',
                      onPressed: () async {
                        await reservationProvider.fetchReservations(
                            'canceled', accessToken);
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
                    ? Center(child: CustomeProgressIndecator(context))
                    : reservationProvider.errorMessage != null
                        ? Center(child: Text(reservationProvider.errorMessage!))
                        : reservationProvider.Myreservations.isNotEmpty
                            ? SingleChildScrollView(child: TicketTrip())
                            : EmptyState(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
