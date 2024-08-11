import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineTileWidget extends StatelessWidget {
  final String time;
  final String description;
  final String location;
  final String up;
  final String down;
  final String total;
  final bool isFirst;
  final bool isLast;
  final bool isCurrent;
  final bool passed;

  TimelineTileWidget({
    required this.time,
    required this.description,
    required this.location,
    required this.up,
    required this.down,
    required this.total,
    required this.isFirst,
    required this.isLast,
    required this.isCurrent,
    required this.passed,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.center,
      lineXY: 0.2,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: isCurrent ? 30 : (passed ? 25 : 20),
        color: isLast
            ? Colors.red
            : isFirst || isCurrent || passed
                ? Color(0xFF0A3D5F)
                : Colors.grey,
        iconStyle: isCurrent
            ? IconStyle(
                iconData: Icons.directions_bus,
                color: Colors.white,
              )
            : null,
        padding: EdgeInsets.all(6),
      ),
      beforeLineStyle: LineStyle(
        color: passed ? Colors.green : Color(0xFF0A3D5F),
        thickness: 3,
      ),
      afterLineStyle: LineStyle(
        color: Color(0xFF0A3D5F),
        thickness: 3,
      ),
      startChild: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time, style: TextStyle(color: Colors.grey, fontSize: 14)),
            Text(
              location,
              style: TextStyle(
                fontSize: 16,
                fontWeight: passed ? FontWeight.bold : FontWeight.w600,
              ),
            ),
            if (description.isNotEmpty)
              Text(description,
                  style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
      ),
      endChild: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Icon(Icons.arrow_upward, color: Colors.green, size: 18),
                SizedBox(height: 4),
                Text(up, style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(width: 16),
            Column(
              children: [
                Icon(Icons.arrow_downward, color: Colors.red, size: 18),
                SizedBox(height: 4),
                Text(down, style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(width: 16),
            Column(
              children: [
                Icon(Icons.person, color: Colors.grey, size: 18),
                SizedBox(height: 4),
                Text(total, style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
