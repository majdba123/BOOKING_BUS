import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/SeatModel.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:provider/provider.dart';

class BusLayout extends StatelessWidget {
  final List<SeatModel> seats;
  final List<String> selectedSeats;
  final Function(String) onSeatTap;

  const BusLayout({
    Key? key,
    required this.seats,
    required this.selectedSeats,
    required this.onSeatTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<BussofSpsccifTripProvider>(context, listen: false);
    int totalSeats = 40;
    int columnsLeft = 2; // Left of the aisle
    int columnsRight = 2; // Right of the aisle
    int totalColumns =
        columnsLeft + columnsRight; // Total seat columns (excluding aisle)
    int rows = (totalSeats / totalColumns).ceil();
    // int columns = 6;
    // int rows = totalSeats ~/ (columns -1 ); // Adjust rows for the aisle

    // Create a 2D list to represent the bus seats layout
    List<List<SeatModel?>> arrangedSeats = List.generate(
      rows,
      (_) => List.generate(totalColumns, (_) => null),
    );

    // Allocate seats, skipping the aisle column (column 2)
    int seatIndex = 0;
    for (int rowIndex = 0; rowIndex < rows; rowIndex++) {
      for (int columnIndex = 0; columnIndex < totalColumns; columnIndex++) {
        if (seatIndex < seats.length) {
          arrangedSeats[rowIndex][columnIndex] = seats[seatIndex];
          seatIndex++;
        }
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryColor, width: 2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Driver\'s Side',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Image.asset(
                    'assets/images/steering-wheel.png',
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount:
                rows * (totalColumns + 1), // +1 for the aisle in the middle
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: totalColumns + 1, // +1 for the aisle
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              int rowIndex = index ~/ (totalColumns + 1);
              int columnIndex = index % (totalColumns + 1);

              // Determine if this position should be an aisle
              if (columnIndex == columnsLeft) {
                return Container(
                  color: Colors.transparent, // Aisle design
                  child: Center(
                    child: Icon(Icons.arrow_downward), // Aisle indicator
                  ),
                );
              }
              int seatColumnIndex =
                  columnIndex < columnsLeft ? columnIndex : columnIndex - 1;
              int actualSeatIndex = rowIndex * totalColumns + seatColumnIndex;
              SeatModel? seat = arrangedSeats[rowIndex][seatColumnIndex];
              bool isActualSeat = actualSeatIndex < seats.length;

              bool isSelected =
                  isActualSeat && selectedSeats.contains(seat!.id);
              ;

              return InkWell(
                onTap: isActualSeat ? () => onSeatTap(seat!.id) : null,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: isActualSeat
                        ? (seat!.status == 0
                            ? (isSelected
                                ? AppColors.primaryColor
                                : Colors.grey)
                            : ((seat!.status == 1 &&
                                        provider.selectedTypeTripIndex == 0) ||
                                    (seat!.status == 2 &&
                                        provider.selectedTypeTripIndex == 1))
                                ? Colors.red
                                : (isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey))
                        : Colors.grey[300],
                    border: isActualSeat
                        ? Border.all(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.black.withOpacity(0.5),
                            width: 1,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      // isActualSeat ? '${seat!.id}' : '', // Display seat ID
                      isActualSeat
                          ? '${actualSeatIndex + 1}'
                          : '', // Display seat ID

                      style: TextStyle(
                        color: isActualSeat ? Colors.white : Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
