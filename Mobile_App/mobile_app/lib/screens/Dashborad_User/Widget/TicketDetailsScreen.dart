import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/My_Reservation.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class TicketDetailsScreen extends StatelessWidget {
  final MYReservation reservation;

  TicketDetailsScreen({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Ticket Details'),
        backgroundColor: Colors.grey[200],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TicketCard(reservation: reservation),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TrackBusSection(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: HelpSection(),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final MYReservation reservation;

  TicketCard({required this.reservation});

  @override
  Widget build(BuildContext context) {
    final qrValidationResult = QrValidator.validate(
      data: reservation.id.toString(),
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );
    if (qrValidationResult.status == QrValidationStatus.error) {
      return Center(
        child: Text('Failed to generate QR code'),
      );
    }

    final qrCode = qrValidationResult.qrCode;
    final painter = QrPainter.withQr(
      qr: qrCode!,
      color: Color(0xFF000000),
      gapless: true,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reservation.from,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Date: today'),
                  ],
                ),
                Icon(Icons.directions_bus, size: 24.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(reservation.to,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Ticket No.: ${reservation.id}'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Passengers'),
                    Text('${reservation.seats.length} Adults'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seat No.'),
                    Text(
                        '${reservation.seats.map((seat) => seat.id).join(", ")}'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ticket Fare'),
                    Text('£${reservation.price}'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
            Text('Ticket Status: CONFIRMED',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            Container(
              height: 200,
              width: 200,
              child: CustomPaint(
                painter: painter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackBusSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Track your bus',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 8.0),
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(12.9715987,
                  77.5945627), // Set the initial location to Bangalore
              zoom: 12,
            ),
            markers: {
              Marker(
                markerId: MarkerId('bus_location'),
                position: LatLng(12.9715987,
                    77.5945627), // Set the marker to the initial location
              ),
            },
          ),
        ),
      ],
    );
  }
}

class HelpSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Handle cancel ticket action
      },
      icon: Icon(Icons.cancel),
      label: Text('Cancel Ticket'),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
    );
  }
}
