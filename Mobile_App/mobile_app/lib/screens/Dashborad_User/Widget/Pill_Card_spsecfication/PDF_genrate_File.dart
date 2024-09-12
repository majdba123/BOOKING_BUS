import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class TiketPdf {
  static Future<void> generatePdf(BuildContext context, String qrData) async {
    if (await Permission.storage.request().isGranted) {
      final reservation =
          Provider.of<TripuserProvider>(context, listen: false).reservation;
      final busprovider =
          Provider.of<BussofSpsccifTripProvider>(context, listen: false);

      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final pdf = pw.Document();

      // Load custom font
      final fontData = await rootBundle
          .load('assets/fonts/Montserrat/Montserrat-ExtraLight.ttf');
      final ttf = pw.Font.ttf(fontData);
      final imageLogo = pw.MemoryImage(
        (await rootBundle.load('assets/images/logo_bus.jpg'))
            .buffer
            .asUint8List(),
      );
      final ticketWidth = 300.0; // in mm
      final ticketHeight = 150.0; // in mm
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(
              ticketWidth * PdfPageFormat.mm, ticketHeight * PdfPageFormat.mm),
          build: (pw.Context context) => pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child:
                      pw.Image(imageLogo, width: 100), // Adjust size as needed
                ),
                pw.SizedBox(height: 14),
                pw.Text(
                  'Bus Trip ID: ${reservation!.busTripId}',
                  style: pw.TextStyle(
                    fontSize: 32,
                  ),
                ),
                pw.SizedBox(height: 28),
                pw.Row(
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Bording Point',
                          style: pw.TextStyle(color: PdfColors.grey),
                        ),
                        pw.Text(reservation.breakName),
                        pw.SizedBox(height: 28),
                        pw.Text(
                          'Price',
                          style: pw.TextStyle(color: PdfColors.grey),
                        ),
                        pw.Text('\$${reservation!.price}'),
                      ],
                    ),
                    pw.Spacer(),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Duration',
                          style: pw.TextStyle(color: PdfColors.grey),
                        ),
                        pw.Text(
                            '${busprovider.busResponses[busprovider.selectIndexOfSpsecifcBustrip].tripDuration}'),
                        pw.SizedBox(height: 28),
                        pw.Text(
                          'Date',
                          style: pw.TextStyle(color: PdfColors.grey),
                        ),
                        pw.Text(currentDate),
                      ],
                    )
                  ],
                ),
                pw.SizedBox(height: 28),
                pw.Divider(),
                pw.SizedBox(height: 28),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Passenger',
                          style: pw.TextStyle(color: PdfColors.grey),
                        ),
                        pw.Text(
                          reservation!.userName,
                          style: pw.TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Total',
                          style: pw.TextStyle(color: PdfColors.grey),
                        ),
                        pw.Text(
                          '\$${reservation!.price}',
                          style: pw.TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 28),
                pw.Divider(),
                pw.SizedBox(height: 28),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'From',
                          style: pw.TextStyle(color: PdfColors.grey),
                        ),
                        pw.Text(
                            '${busprovider.busResponses[busprovider.selectIndexOfSpsecifcBustrip].from ?? 'N/A'}'),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'To',
                          style: pw.TextStyle(color: PdfColors.grey),
                        ),
                        pw.Text(
                            '${busprovider.busResponses[busprovider.selectIndexOfSpsecifcBustrip].to ?? 'N/A'}'),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 28),
                pw.Divider(),
                pw.SizedBox(height: 28),
                qrData.isNotEmpty
                    ? pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: qrData,
                        width: 200,
                        height: 200,
                      )
                    : pw.Text('Loading QR Code...'),
                pw.SizedBox(height: 28),
                pw.Text(
                  'Reservation ID: ${reservation!.reservationId}',
                  style: pw.TextStyle(
                    fontSize: 10,
                  ),
                ),
                pw.SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );

      final directory = await getExternalStorageDirectory();
      final downloadPath = "${directory?.path}/Download/ticket.pdf";
      print(downloadPath);
      // Ensure the "Download" directory exists
      final downloadDir = Directory("${directory?.path}/Download");
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // Save the PDF file
      final file = File(downloadPath);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to Downloads: ticket.pdf')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }
}
