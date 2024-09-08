import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Seat.dart';
import 'package:mobile_app/Api_Services/Company/Seat_Provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Seat.dart';
import 'package:mobile_app/Api_Services/Company/Seat_Provider.dart';
import 'package:provider/provider.dart';

class BusSeatLayoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Bus Booking'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0.0,
      ),
      body: Consumer<SeatProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.Seats.isEmpty) {
            return Center(child: Text('No seats available'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Fixed number of columns
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: provider.Seats.length,
                itemBuilder: (context, index) {
                  Seat seat = provider.Seats[index];
                  return SeatWidget(
                    name: ' ${index+1}',
                    color: getSeatColor(seat.status),
                    onTap: () {
                      // Handle seat tap
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Color getSeatColor(int status) {
    switch (status) {
      case 0:
        return Colors.green[100]!;
      case 1:
        return Colors.red[100]!;
      default:
        return Colors.grey[200]!;
    }
  }
}



class SeatWidget extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback? onTap;

  SeatWidget({required this.name, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 5 - 4;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: width,
        height: width / 1.5,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
