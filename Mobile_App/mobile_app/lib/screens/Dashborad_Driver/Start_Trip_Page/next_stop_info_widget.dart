import 'package:flutter/material.dart';

class NextStopInfoWidget extends StatelessWidget {
  final bool showTimeline;
  final VoidCallback onToggleVisibility;

  NextStopInfoWidget({
    required this.showTimeline,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Next Stop',
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Row(
              children: [
                Text(
                  '24 mins',
                  style: TextStyle(
                    fontSize: screenHeight * 0.028,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Icon(Icons.arrow_upward, color: Colors.green),
                SizedBox(width: screenWidth * 0.01),
                Text(
                  'Ascend 4',
                  style: TextStyle(
                    fontSize: screenHeight * 0.018,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Icon(Icons.arrow_downward, color: Colors.red),
                SizedBox(width: screenWidth * 0.01),
                Text(
                  'Drop 12',
                  style: TextStyle(
                    fontSize: screenHeight * 0.018,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              '340 kms left · 36 passengers left',
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            showTimeline ? Icons.expand_less : Icons.expand_more,
            color: Colors.blueAccent,
            size: screenHeight * 0.04,
          ),
          onPressed: onToggleVisibility,
        ),
      ],
    );
  }
}
