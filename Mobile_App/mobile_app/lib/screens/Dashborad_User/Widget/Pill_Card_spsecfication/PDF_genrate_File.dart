import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PdfGeneratorPage extends StatefulWidget {
  @override
  _PdfGeneratorPageState createState() => _PdfGeneratorPageState();
}

class _PdfGeneratorPageState extends State<PdfGeneratorPage> {
  bool _isLoading = false;
  String qrData = '';

  Future<void> _generateAndDownloadPdf() async {
    setState(() {
      _isLoading = true;
    });

    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      // Fetch the reservation and location details
      final reservation =
          Provider.of<TripuserProvider>(context, listen: false).reservation;
      final fromLocation =
          Provider.of<TripuserProvider>(context, listen: false).from;
      final toLocation =
          Provider.of<TripuserProvider>(context, listen: false).to;
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Create a PDF document
      final pdf = pw.Document();

      // Add a page to the PDF
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Bus Trip Ticket', style: pw.TextStyle(fontSize: 32)),
                pw.SizedBox(height: 16),
                pw.Text('Bus Trip ID: ${reservation?.busTripId ?? 'N/A'}'),
                pw.Text('From: ${fromLocation ?? 'N/A'}'),
                pw.Text('To: ${toLocation ?? 'N/A'}'),
                pw.Text('Date: $currentDate'),
                pw.Text(
                    'Seats: ${reservation?.seats.map((seat) => seat.seatId).join(", ") ?? 'N/A'}'),
                pw.SizedBox(height: 16),
                pw.Text('Price: \$${reservation?.price ?? 'N/A'}'),
                pw.SizedBox(height: 16),
                pw.Text('Passenger: ${reservation?.userName ?? 'N/A'}'),
                pw.SizedBox(height: 16),
                pw.Text(
                    'Reservation ID: ${reservation?.reservationId ?? 'N/A'}',
                    style: pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 16),
                qrData.isNotEmpty
                    ? pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: qrData,
                        width: 100,
                        height: 100,
                      )
                    : pw.Text('No QR code available'),
              ],
            ),
          ),
        ),
      );

      // Get the path to the Downloads directory
      final directory = await getExternalStorageDirectory();
      final downloadPath = "${directory?.path}/Download/ticket.pdf";

      // Save the PDF file to Downloads
      final file = File(downloadPath);
      await file.writeAsBytes(await pdf.save());

      // Notify user of success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to Downloads: ticket.pdf')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate PDF')),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _generateAndDownloadPdf,
                child: Text('Download PDF'),
              ),
      ),
    );
  }
}
