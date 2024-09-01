import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class drivingScore extends StatelessWidget {
  const drivingScore({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double weightSpeed = 0.6;
    double weightDriver = 0.4;
    var Drivermodel =
        Provider.of<DriverProvider>(context, listen: false).RateDriver;
    double drivingScore = (Drivermodel!.Speed_Rateing * weightSpeed) +
        (Drivermodel!.Driving_Rateing * weightDriver);

    return Container(
      width: screenHeight * 0.2,
      height: screenHeight * 0.2,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 50,
                color: Colors.red,
                startWidth: 10,
                endWidth: 10,
              ),
              GaugeRange(
                startValue: 50,
                endValue: 75,
                color: Colors.orange,
                startWidth: 10,
                endWidth: 10,
              ),
              GaugeRange(
                startValue: 75,
                endValue: 100,
                color: Colors.green,
                startWidth: 10,
                endWidth: 10,
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: drivingScore,
                needleColor: Colors.black,
                needleEndWidth: 5,
                lengthUnit: GaugeSizeUnit.factor,
                needleLength: 0.6,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Container(
                  child: Text(
                    '${drivingScore}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                angle: 90,
                positionFactor: 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
