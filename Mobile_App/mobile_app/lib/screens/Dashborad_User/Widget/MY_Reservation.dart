import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/My_Reservation.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';
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
    final reservationProvider = Provider.of<TripuserProvider>(context);
    var accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bookings'),
        backgroundColor: Colors.grey[200],
      ),
      body: Column(
        children: [
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

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  FilterButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final MYReservation reservation;

  BookingCard({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${reservation.from} - ${reservation.to}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '£${reservation.price}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16.0, color: Colors.grey),
                    SizedBox(width: 4.0),
                    Text('Date: tody', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.person, size: 16.0, color: Colors.grey),
                    SizedBox(width: 4.0),
                    Text('${reservation.seats.length} Persons',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_bus, size: 16.0, color: Colors.grey),
                    SizedBox(width: 4.0),
                    Text('R', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16.0, color: Colors.grey),
                    SizedBox(width: 4.0),
                    Text('Duration: 3:05 hrs',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16.0, color: Colors.grey),
                    SizedBox(width: 4.0),
                    Text('S-Point: ${reservation.breakName}',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.event_seat, size: 16.0, color: Colors.grey),
                    SizedBox(width: 4.0),
                    Text(
                        'Seats: ${reservation.seats.map((seat) => seat.id).join(", ")}',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No active bookings found',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor),
          ),
          SizedBox(height: 8.0),
          Text(
            "We can't find any bookings made by you. But\nyou can still make bookings.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 16.0),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DashboardUser()));
            },
            child: Text('Book tickets'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              side: BorderSide(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
