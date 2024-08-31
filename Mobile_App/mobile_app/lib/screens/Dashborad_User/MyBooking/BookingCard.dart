import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/My_Reservation.dart';
import 'package:ticket_widget/ticket_widget.dart';

class BookingCard extends StatelessWidget {
  final MYReservation reservation;

  BookingCard({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TicketWidget(
        // color: Colors.blueGrey,
        width: 350.0,
        height: 200.0,
        isCornerRounded: true,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${reservation.from} - ${reservation.to}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                       ),
                ),
                Text(
                  '£${reservation.price}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                       ),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16.0,  ),
                    SizedBox(width: 4.0),
                    Text(
                      'Date: tody',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                           
                          fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16.0,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      '${reservation.seats.length} Persons',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                           ),
                    ),
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
                    Icon(Icons.directions_bus, size: 16.0,  ),
                    SizedBox(width: 4.0),
                    Text(
                      'R: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                           
                          fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16.0,  ),
                    SizedBox(width: 4.0),
                    Text(
                      'Duration:  3:05 hrs',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                           
                          fontSize: 14),
                    ),
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
                    Icon(Icons.location_on, size: 16.0,  ),
                    SizedBox(width: 4.0),
                    Text(
                      'S-Point: ${reservation.breakName}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          
                          fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.event_seat, size: 16.0,  ),
                    SizedBox(width: 4.0),
                    Text(
                      'Seats: ${reservation.seats.map((seat) => seat.id).join(", ")}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                           
                          fontSize: 14),
                    ),
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
