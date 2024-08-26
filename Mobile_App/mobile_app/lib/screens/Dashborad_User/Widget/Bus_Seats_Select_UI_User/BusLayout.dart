import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/SeatModel.dart';

class BusLayout extends StatelessWidget {
  final List<SeatModel> seats;
  final List<int> selectedSeats;
  final Function(int) onSeatTap;

  const BusLayout({
    Key? key,
    required this.seats,
    required this.selectedSeats,
    required this.onSeatTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalSeats = 40;
    int columns = 5;
    int rows = totalSeats ~/ (columns - 1); // Adjust rows for the aisle

    // Create a 2D list to represent the bus seats layout
    List<List<SeatModel?>> arrangedSeats = List.generate(
      rows,
      (_) => List.generate(columns, (_) => null),
    );

    // Allocate seats, skipping the aisle column (column 2)
    int seatIndex = 0;
    for (int rowIndex = 0; rowIndex < rows; rowIndex++) {
      for (int columnIndex = 0; columnIndex < columns; columnIndex++) {
        if (columnIndex == 2) {
          continue; // Skip the aisle column
        }
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
            itemCount: totalSeats,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              int rowIndex = index ~/ columns;
              int columnIndex = index % columns;

              // Determine if this position should be an aisle
              if (columnIndex == 2) {
                return Container(); // Represents the aisle
              }

              SeatModel? seat = arrangedSeats[rowIndex][columnIndex];

              bool isActualSeat = seat != null;
              bool isSelected =
                  isActualSeat && selectedSeats.contains(seat!.id);

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
                            : Colors.red)
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
                      isActualSeat ? '${seat!.id}' : '', // Display seat ID
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
