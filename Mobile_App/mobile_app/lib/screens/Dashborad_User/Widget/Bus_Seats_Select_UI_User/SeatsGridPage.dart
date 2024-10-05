import 'package:flutter/material.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/ConfirmButton.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/DeckSwitch.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/seatLegendRow.dart';
import 'package:mobile_app/widgets/CustomeCirculerProgress.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Data_Models/SeatModel.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/BusHeader.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/BusLayout.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/payment/TicketDetailObject.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/PassengerDetailsPage/custom_button.dart';

class SeatsGridPage extends StatefulWidget {
  @override
  _SeatsGridPageState createState() => _SeatsGridPageState();
}

class _SeatsGridPageState extends State<SeatsGridPage> {
  List<String> selectedSeats = [];
  bool showUpperDeck = false;
  late BussofSpsccifTripProvider providerSpecificBusTrip;

  @override
  void initState() {
    super.initState();
    selectedSeats = [];
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    providerSpecificBusTrip =
        Provider.of<BussofSpsccifTripProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    providerSpecificBusTrip.getSeatOfBusTrip(
        providerSpecificBusTrip
            .busResponses[providerSpecificBusTrip.selectIndexOfSpsecifcBustrip]
            .bus_trip_id,
        authProvider.accessToken);
    // });
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
      body: Consumer<BussofSpsccifTripProvider>(
        builder: (context, busProvider, child) {
          // Check if the data is still loading
          if (busProvider.isLoading) {
            return Center(
              child: CustomeProgressIndecator(context),
            );
          }
          List<SeatModel> lowerDeckSeats = busProvider.seats.take(40).toList();
          List<SeatModel> upperDeckSeats = busProvider.seats.length > 40
              ? busProvider.seats.skip(40).take(40).toList()
              : [];

          return SingleChildScrollView(
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
          );
        },
      ),
    );
  }

  void _onSeatTap(String seatId) {
    setState(() {
      if (selectedSeats.contains(seatId)) {
        selectedSeats.remove(seatId);
      } else {
        selectedSeats.add(seatId);
      }
    });
  }

  void _confirmSelection() {
    int price_tiket = providerSpecificBusTrip
        .busResponses[providerSpecificBusTrip.selectIndexOfSpsecifcBustrip]
        .price;
    for (String seatId in selectedSeats) {
      String seatType = "normal";
      int seatPrice = price_tiket;

      providerSpecificBusTrip.addTicketDetail(
        TicketDetail(type: seatType, quantity: 1, price: seatPrice),
      );
    }

    providerSpecificBusTrip.selectSeat(selectedSeats);
    providerSpecificBusTrip.calculatePrice(selectedSeats.length, price_tiket);

    if (selectedSeats.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PassengerDetailsPage()),
      );
    } else {
      showErrorDialog(context, 'You Must Chosse A Seat First  ');
    }
  }
}
