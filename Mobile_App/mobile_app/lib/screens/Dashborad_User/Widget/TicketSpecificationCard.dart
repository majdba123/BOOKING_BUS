import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.read<TripuserProvider>();
    var Rservation =
        provider.Myreservations[provider.specificIndexReservation!];
    final qrValidationResult = QrValidator.validate(
      data: provider.Myreservations[provider.specificIndexReservation!].id,
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

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 32),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(26),
              margin: EdgeInsets.fromLTRB(26, 26, 26, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 4,
                  )
                ],
              ),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/logo_bus.jpg', // Change to your bus logo
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          '${Rservation.company_name.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 32,
                          ),
                        ),
                      ),
                      SizedBox(height: 28),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pickup Point',
                                style: TextStyle(color: veppoLightGrey),
                              ),
                              Text(Rservation.Pickup_Point),
                              SizedBox(height: 28),
                              Text(
                                'Price',
                                style: TextStyle(color: veppoLightGrey),
                              ),
                              Text('\$${Rservation.price}'),
                              SizedBox(height: 28),
                              Text(
                                'Start-Trip',
                                style: TextStyle(color: veppoLightGrey),
                              ),
                              Text(Rservation.start_time),
                              SizedBox(height: 28),
                              Text(
                                'From',
                                style: TextStyle(color: veppoLightGrey),
                              ),
                              Text('${Rservation.from}'),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Duration',
                                style: TextStyle(color: veppoLightGrey),
                              ),
                              Text('${Rservation.trip_Duration}'),
                              SizedBox(height: 28),
                              Text(
                                'Date',
                                style: TextStyle(color: veppoLightGrey),
                              ),
                              Text(Rservation.Date),
                              SizedBox(height: 28),
                              Text(
                                'End-Trip',
                                style: TextStyle(color: veppoLightGrey),
                              ),
                              Text(Rservation.end_time),
                              SizedBox(height: 28),
                              Text(
                                'To',
                                style: TextStyle(color: veppoLightGrey),
                              ),
                              Text('${Rservation.to}'),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 28),
                  Divider(),
                  SizedBox(height: 28),
                  Container(
                      height: 200,
                      width: 200,
                      child: CustomPaint(
                        painter: painter,
                      )),
                ],
              ),
            ),
            Text(
              'Reservation ID: ${Rservation.id}',
              style: TextStyle(
                color: veppoLightGrey,
                fontSize: 10,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
