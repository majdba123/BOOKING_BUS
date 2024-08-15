import 'package:flutter/material.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/Trip_by_Path.dart';
import 'package:mobile_app/Data_Models/seat_model.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/BusHeader.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/BusLayout.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/SeatLegend.dart';
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
  bool showUpperDeck = false;

  @override
  Widget build(BuildContext context) {
    List<SeatModel> lowerDeckSeats = widget.seats.take(40).toList();
    List<SeatModel> upperDeckSeats =
        widget.seats.length > 40 ? widget.seats.skip(40).take(40).toList() : [];

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
                  BusHeader(
                    companyName: widget.companyName,
                    from: widget.from,
                    to: widget.to,
                    fromTime: widget.fromTime,
                    toTime: widget.toTime,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SeatLegend(label: 'Booked', color: Colors.red),
                        SizedBox(width: 16.0),
                        SeatLegend(label: 'Available', color: Colors.grey),
                        SizedBox(width: 16.0),
                        SeatLegend(
                            label: 'Your Seat', color: AppColors.primaryColor),
                      ],
                    ),
                  ),
                  if (upperDeckSeats.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Lower Deck', style: TextStyle(fontSize: 16)),
                          Switch(
                            value: showUpperDeck,
                            onChanged: (value) {
                              setState(() {
                                showUpperDeck = value;
                              });
                            },
                            activeColor: AppColors.primaryColor,
                          ),
                          Text('Upper Deck', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 1500),
              child: BusLayout(
                seats: showUpperDeck ? upperDeckSeats : lowerDeckSeats,
                selectedSeats: selectedSeats,
                onSeatTap: (int seatId) {
                  setState(() {
                    if (selectedSeats.contains(seatId)) {
                      selectedSeats.remove(seatId);
                    } else {
                      selectedSeats.add(seatId);
                    }
                  });
                },
              ),
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 3500),
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
                          return Colors.grey;
                        return AppColors.primaryColor;
                      },
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
}
