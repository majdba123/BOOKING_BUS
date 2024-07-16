import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/flight_model.dart';
import 'package:mobile_app/Data_Models/seat_model.dart';
import 'package:mobile_app/constants.dart';
import 'package:delayed_display/delayed_display.dart';

class SeatsGridPage extends StatefulWidget {
  SeatsGridPage({Key? key}) : super(key: key);

  @override
  _SeatsGridPageState createState() => _SeatsGridPageState();
}

class _SeatsGridPageState extends State<SeatsGridPage> {
  final FlightModel flight = FlightModel(
    id: "1",
    logo: "assets/logo.png",
    title: "Sample Flight",
    price: 49.00,
    seats: List.generate(32, (index) => SeatModel(available: index % 2 == 0)),
  );

  List<int> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 1.0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.26,
                color: AppColors.primaryColor,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 23.0,
                  bottom: 20.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(2.0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Name',
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
                          'Start time',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'End time',
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
                          'Florianópolis',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' .......... ',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Icon(Icons.directions_bus, color: Colors.grey),
                        Text(
                          ' .......... ',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        Text(
                          'Porto Alegre',
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
                          'Date now',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow, size: 12),
                            SizedBox(width: 4.0),
                            Text('Rating',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            DelayedDisplay(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                margin: EdgeInsets.fromLTRB(64, 16, 64, 16),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Spacer(),
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(color: AppColors.primaryColor, width: 2),
                          ),
                        ),
                        Spacer(flex: 2),
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(color: AppColors.primaryColor, width: 2),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                        border: Border.all(color: AppColors.primaryColor, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                        child: GridView.builder(
                          itemCount: flight.seats!.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // 4 items per row
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0,
                          ),
                          itemBuilder: (context, index) {
                            if (index % 4 == 2) {
                              return Container(); // Empty space for aisle
                            }
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (selectedSeats.contains(index)) {
                                    selectedSeats.remove(index);
                                  } else {
                                    selectedSeats.add(index);
                                  }
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(16),
                                child: Image.asset(
                                  (flight.seats![index] as SeatModel).available!
                                      ? selectedSeats.contains(index)
                                          ? "assets/images/seats/seat_3.jpg" // Image with 3 dots for selected seats
                                          : "assets/images/seats/seat_1.jpg"
                                      : "assets/images/seats/seat_2.jpg",
                                  width: 28,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/seats/seat_1.jpg',
                    width: 28,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'available',
                    style: TextStyle(
                      color: veppoLightGrey,
                    ),
                  ),
                  SizedBox(width: 12),
                  Image.asset(
                    'assets/images/seats/seat_2.jpg',
                    width: 28,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'booked',
                    style: TextStyle(
                      color: veppoLightGrey,
                    ),
                  ),
                  SizedBox(width: 12),
                  Image.asset(
                    'assets/images/seats/seat_3.jpg',
                    width: 28,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'selected',
                    style: TextStyle(
                      color: veppoLightGrey,
                    ),
                  ),
                ],
              ),
            ),
            DelayedDisplay(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the selected seats here
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
                      'Proceed to payment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
