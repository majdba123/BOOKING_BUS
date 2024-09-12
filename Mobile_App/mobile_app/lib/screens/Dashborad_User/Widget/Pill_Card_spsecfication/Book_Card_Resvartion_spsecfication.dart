import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Pill_Card_spsecfication/PDF_genrate_File.dart';

import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:barcode_widget/barcode_widget.dart';

class TripTicketPage extends StatefulWidget {
  @override
  _TripTicketPageState createState() => _TripTicketPageState();
}

class _TripTicketPageState extends State<TripTicketPage> {
  String qrData = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateQrData();
  }

  void _generateQrData() {
    final reservation =
        Provider.of<TripuserProvider>(context, listen: false).reservation;

    final data = '${reservation!.reservationId}';

    setState(() {
      qrData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservation = Provider.of<TripuserProvider>(context).reservation;
    final busprovider = Provider.of<BussofSpsccifTripProvider>(context);
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (reservation == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: Text('No reservation found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text('Booking details',
            style: TextStyle(fontSize: 18, color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.download),
            onPressed: () => TiketPdf.generatePdf(context, qrData),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                        SizedBox(height: 14),
                        Text(
                          'Bus Trip ID: ${reservation.busTripId}',
                          style: TextStyle(
                            fontSize: 32,
                          ),
                        ),
                        SizedBox(height: 28),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bording Point',
                                  style: TextStyle(color: veppoLightGrey),
                                ),
                                Text(reservation.breakName),
                                SizedBox(height: 28),
                                Text(
                                  'Price',
                                  style: TextStyle(color: veppoLightGrey),
                                ),
                                Text('\$${reservation.price}'),
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
                                Text(
                                    '${busprovider.busResponses[busprovider.selectIndexOfSpsecifcBustrip].tripDuration}'),
                                SizedBox(height: 28),
                                Text(
                                  'Date',
                                  style: TextStyle(color: veppoLightGrey),
                                ),
                                Text(currentDate),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 28),
                    Divider(),
                    SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Passenger',
                              style: TextStyle(color: veppoLightGrey),
                            ),
                            Text(
                              reservation.userName,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(color: veppoLightGrey),
                            ),
                            Text(
                              '\$${reservation.price}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 28),
                    Divider(),
                    SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'From',
                              style: TextStyle(color: veppoLightGrey),
                            ),
                            Text(
                                '${busprovider.busResponses[busprovider.selectIndexOfSpsecifcBustrip].from}' ??
                                    'N/A'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'To',
                              style: TextStyle(color: veppoLightGrey),
                            ),
                            Text(
                                '${busprovider.busResponses[busprovider.selectIndexOfSpsecifcBustrip].to}' ??
                                    'N/A'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 28),
                    Divider(),
                    SizedBox(height: 28),
                    qrData.isNotEmpty
                        ? BarcodeWidget(
                            barcode: Barcode.qrCode(),
                            data: qrData,
                            width: 200,
                            height: 200,
                          )
                        : CircularProgressIndicator(),
                  ],
                ),
              ),
              Text(
                'Reservation ID: ${reservation.reservationId}',
                style: TextStyle(
                  color: veppoLightGrey,
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 20),
              Container(
                // width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardUser()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    child: Text(
                      'Go to Dashboard',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
