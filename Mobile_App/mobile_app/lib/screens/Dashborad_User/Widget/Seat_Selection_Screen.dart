import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/Trip_by_Path.dart';
import 'package:mobile_app/Data_Models/seat_model.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/choose_break_place.dart';
import 'package:provider/provider.dart';

class SeatsGridPage extends StatefulWidget {
  final String companyName;
  final String from;
  final String to;
  final String fromTime;
  final String toTime;
  final List<SeatModel> seats;

  SeatsGridPage({
    Key? key,
    required this.companyName,
    required this.from,
    required this.to,
    required this.fromTime,
    required this.toTime,
    required this.seats,
  }) : super(key: key);

  @override
  _SeatsGridPageState createState() => _SeatsGridPageState();
}

class _SeatsGridPageState extends State<SeatsGridPage> {
  List<int> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    List<SeatModel> lowerDeckSeats = widget.seats.take(24).toList();
    List<SeatModel> upperDeckSeats =
        widget.seats.length > 24 ? widget.seats.skip(24).take(24).toList() : [];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DelayedDisplay(
              delay: Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: AppColors.primaryColor,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 28.0,
                      bottom: 20.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.companyName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.fromTime,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.toTime,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.from,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.directions_bus, color: Colors.grey),
                            Text(
                              widget.to,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd').format(DateTime.now()),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 12),
                                SizedBox(width: 4.0),
                                Text('Rating',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSeatLegend('Booked', Colors.red),
                        buildSeatLegend('Available', Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Lower Deck
            if (lowerDeckSeats.isNotEmpty) ...[
              DelayedDisplay(
                delay: Duration(milliseconds: 1000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Lower Deck', style: TextStyle(fontSize: 18)),
                ),
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 1500),
                child: buildDeckLayout(lowerDeckSeats),
              ),
            ],
            // Upper Deck
            if (upperDeckSeats.isNotEmpty) ...[
              DelayedDisplay(
                delay: Duration(milliseconds: 2000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Upper Deck', style: TextStyle(fontSize: 18)),
                ),
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 2500),
                child: buildDeckLayout(upperDeckSeats),
              ),
            ],
            // Footer with seat selection summary

            // DelayedDisplay(
            //   delay: Duration(milliseconds: 3000),
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         buildSeatLegend('Available', Colors.grey),
            //         buildSeatLegend('Booked', Colors.red),
            //         buildSeatLegend('Your Seat', AppColors.primaryColor),
            //       ],
            //     ),
            //   ),
            // ),
            DelayedDisplay(
              delay: Duration(milliseconds: 1700),
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    var bus_provider =
                        Provider.of<TripuserProvider>(context, listen: false);
                    Provider.of<TripuserProvider>(context, listen: false)
                        .selectSeat(selectedSeats);
                    Provider.of<TripuserProvider>(context, listen: false)
                        .calculatePrice(
                            selectedSeats.length, bus_provider.price_tiket);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PassengerDetailsPage()));
                    print('Selected seats: $selectedSeats');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return veppoLightGrey;
                        return AppColors.primaryColor;
                      },
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDeckLayout(List<SeatModel> seats) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryColor, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: seats.length, // Number of seats
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 items per row
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.0, // Make seats square
        ),
        itemBuilder: (context, index) {
          SeatModel seat = seats[index];
          bool isSelected = selectedSeats.contains(seat.id);

          return InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedSeats.remove(seat.id);
                } else {
                  selectedSeats.add(seat.id);
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: seat.status == 0
                    ? isSelected
                        ? AppColors.primaryColor
                        : Colors.grey
                    : Colors.red,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSeatLegend(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }
}
