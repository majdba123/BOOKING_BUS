import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineTileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(
      builder: (context, provider, child) {
        var stops = provider.TripDriverDetail?.breaks_data;

        if (stops == null || stops.isEmpty) {
          return Center(child: Text('No stop details available'));
        }

        return Column(
          children: stops.asMap().entries.map((entry) {
            int index = entry.key;
            var stop = entry.value;
            bool isFirst = index == 0;
            bool isLast = index == stops.length - 1;
            bool isCurrent = index == provider.currentStopIndex;
            bool passed = index < provider.currentStopIndex;
            provider.settotalPassenger(stop.passengers_count);

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
                    Text('time:30',
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Text(
                      stop.break_name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: passed ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                    if (index == 0)
                      Text('Starting Point',
                          style: TextStyle(color: Colors.red, fontSize: 12)),
                    if (index == stops.length - 1)
                      Text('Ending Point',
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
                        Text('${stop.passengers_count}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(width: 16),
                    Column(
                      children: [
                        Icon(Icons.person, color: Colors.grey, size: 18),
                        SizedBox(height: 4),
                        Text('${provider.totalPassenger}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
