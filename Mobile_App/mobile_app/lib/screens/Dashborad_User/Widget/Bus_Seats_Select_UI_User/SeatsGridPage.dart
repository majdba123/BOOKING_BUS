import 'package:flutter/material.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/ConfirmButton.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/DeckSwitch.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/seatLegendRow.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Data_Models/SeatModel.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/BusHeader.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/BusLayout.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/payment/TicketDetailObject.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/PassengerDetailsPage/custom_button.dart';

class SeatsGridPage extends StatefulWidget {
  @override
  _SeatsGridPageState createState() => _SeatsGridPageState();
}

class _SeatsGridPageState extends State<SeatsGridPage> {
  List<int> selectedSeats = [];
  bool showUpperDeck = false;
  late final BussofSpsccifTripProvider providerSpecificBusTrip;

  @override
  void initState() {
    super.initState();
    providerSpecificBusTrip =
        Provider.of<BussofSpsccifTripProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    providerSpecificBusTrip.getSeatOfBusTrip(
        providerSpecificBusTrip.tripid, authProvider.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    List<SeatModel> lowerDeckSeats =
        providerSpecificBusTrip.seats.take(40).toList();
    List<SeatModel> upperDeckSeats = providerSpecificBusTrip.seats.length > 40
        ? providerSpecificBusTrip.seats.skip(40).take(40).toList()
        : [];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DelayedDisplay(
              delay: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BusHeader(),
                  const SeatLegendRow(),
                  if (upperDeckSeats.isNotEmpty)
                    DeckSwitch(
                      showUpperDeck: showUpperDeck,
                      onToggle: (value) {
                        setState(() {
                          showUpperDeck = value;
                        });
                      },
                    ),
                ],
              ),
            ),
            DelayedDisplay(
              delay: const Duration(milliseconds: 2000),
              child: BusLayout(
                seats: showUpperDeck ? upperDeckSeats : lowerDeckSeats,
                selectedSeats: selectedSeats,
                onSeatTap: _onSeatTap,
              ),
            ),
            DelayedDisplay(
              delay: const Duration(milliseconds: 2000),
              child: ConfirmButton(
                onPressed: _confirmSelection,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSeatTap(int seatId) {
    setState(() {
      if (selectedSeats.contains(seatId)) {
        selectedSeats.remove(seatId);
      } else {
        selectedSeats.add(seatId);
      }
    });
  }

  void _confirmSelection() {
    var busProvider = Provider.of<TripuserProvider>(context, listen: false);

    // Adding the selected seats to the provider
    for (int seatId in selectedSeats) {
      String seatType = busProvider.getSeatType(seatId);
      int seatPrice = busProvider.price_trip;

      busProvider.addTicketDetail(
        TicketDetail(type: seatType, quantity: 1, price: seatPrice),
      );
    }

    busProvider.selectSeat(selectedSeats);
    busProvider.calculatePrice(selectedSeats.length, busProvider.price_tiket);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PassengerDetailsPage()),
    );
  }
}
