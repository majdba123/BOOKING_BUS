import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_User/Dashbord.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:barcode_widget/barcode_widget.dart';

class TripTicketPage extends StatefulWidget {
  @override
  _TripTicketPageState createState() => _TripTicketPageState();
}

class _TripTicketPageState extends State<TripTicketPage> {
  String qrData = '';

  @override
  void initState() {
    super.initState();
    _generateQrData();
  }

  void _generateQrData() {
    final reservation =
        Provider.of<TripuserProvider>(context, listen: false).reservation;
    if (reservation != null) {
      final fromLocation =
          Provider.of<TripuserProvider>(context, listen: false).from;
      final toLocation =
          Provider.of<TripuserProvider>(context, listen: false).to;
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final data =
          'ReservationID:${reservation.reservationId}|User:${reservation.userName}|Seats:${reservation.seats.map((seat) => seat.seatId).join(",")}|From:${fromLocation ?? "N/A"}|To:${toLocation ?? "N/A"}|Date:$currentDate';

      setState(() {
        qrData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservation = Provider.of<TripuserProvider>(context).reservation;
    final fromLocation = Provider.of<TripuserProvider>(context).from;
    final toLocation = Provider.of<TripuserProvider>(context).to;
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
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: Text(''),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(15),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 32, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Booking details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
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
                                  'Start Point',
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
                                  'Seats',
                                  style: TextStyle(color: veppoLightGrey),
                                ),
                                ...reservation.seats.map<Widget>((seat) {
                                  return Text('Seat ID: ${seat.seatId}');
                                }).toList(),
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
                            Text(fromLocation ?? 'N/A'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'To',
                              style: TextStyle(color: veppoLightGrey),
                            ),
                            Text(toLocation ?? 'N/A'),
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
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardUser()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF083B4C),
                    padding: EdgeInsets.all(8.0),
                    textStyle: TextStyle(fontSize: 16, color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Container(
                    width: 160,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text('Exit', style: TextStyle(color: Colors.white)),
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