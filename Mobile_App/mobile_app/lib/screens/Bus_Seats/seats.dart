import 'package:flutter/material.dart';



class BusSeatLayoutPage extends StatefulWidget {
  @override
  _BusSeatLayoutPageState createState() => _BusSeatLayoutPageState();
}

class _BusSeatLayoutPageState extends State<BusSeatLayoutPage> {
  final List<Seat> seats = [
    Seat(id: '1A', isAvailable: true),
    Seat(id: '1B', isAvailable: false),
    Seat(id: '1C', isAvailable: true),
    Seat(id: '1D', isAvailable: false),
    Seat(id: '2A', isAvailable: true),
    Seat(id: '2B', isAvailable: false),
    Seat(id: '2C', isAvailable: true),
    Seat(id: '2D', isAvailable: false),
    Seat(id: '3A', isAvailable: true),
    Seat(id: '3B', isAvailable: false),
    Seat(id: '3C', isAvailable: true),
    Seat(id: '3D', isAvailable: false),
    // Add more seats as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Seat Layout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Bus Seat Layout',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Number of seats per row
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: seats.length,
                itemBuilder: (context, index) {
                  final seat = seats[index];
                  return SeatWidget(seat: seat);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Seat {
  final String id;
  final bool isAvailable;

  Seat({required this.id, required this.isAvailable});
}

class SeatWidget extends StatelessWidget {
  final Seat seat;

  SeatWidget({required this.seat});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: seat.isAvailable ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          seat.id,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
