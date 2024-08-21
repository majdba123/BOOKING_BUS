import 'package:mobile_app/Data_Models/BusInfoTrip.dart';

class Trip {
  final int pathId;
  final String price;
  final List<int> breaksIds;
  final List<BusInfo> busIds;

  Trip({
    required this.pathId,
    required this.price,
    required this.breaksIds,
    required this.busIds,
  });
}