import 'package:flutter/material.dart';

void main() {
  runApp(TripApp());
}

class TripApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip List',
      home: AllTrip(),
    );
  }
}

class AllTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip List'),
      ),
      body: TripList(
        trips: List.generate(
          10,
          (index) => Trip(
            pathId: 'P${1000 + index}',
            price: 100.0 + index * 10,
            breakPlaces: List.generate(3, (i) => 'Place ${i + 1}'),
            busInfo: List.generate(
              2,
              (i) => BusInfo(
                busId: 'B${index * 2 + i}',
                type: i % 2 == 0 ? 'All' : 'Going',
                startTime: '${8 + i}:00 AM',
                endTime: '${10 + i}:00 AM',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TripList extends StatelessWidget {
  final List<Trip> trips;

  TripList({required this.trips});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        return TripCard(trip: trips[index]);
      },
    );
  }
}

class TripCard extends StatelessWidget {
  final Trip trip;

  TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Path ID: ${trip.pathId}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 10),
            Text(
              'Price: \$${trip.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
            SizedBox(height: 10),
            ExpansionTile(
              title: Text(
                'Break Places',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              children: trip.breakPlaces
                  .map((place) => ListTile(
                        title: Text(
                          place,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ))
                  .toList(),
            ),
            ExpansionTile(
              title: Text(
                'Bus Info',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
              children: trip.busInfo
                  .map((info) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/bus_icon.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Bus ID: ${info.busId}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                  Text('Type: ${info.type}', style: TextStyle(fontSize: 14, color: Colors.black54)),
                                  Text('Start Time: ${info.startTime}', style: TextStyle(fontSize: 14, color: Colors.black54)),
                                  Text('End Time: ${info.endTime}', style: TextStyle(fontSize: 14, color: Colors.black54)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle delete action
                  },
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTripPage(trip: trip),
                      ),
                    );
                  },
                  child: Text('Update'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class EditTripPage extends StatefulWidget {
  final Trip trip;

  EditTripPage({required this.trip});

  @override
  _EditTripPageState createState() => _EditTripPageState();
}

class _EditTripPageState extends State<EditTripPage> {
  late String selectedPathId;
  late String selectedArea;
  List<String> breakPlaces = []; // Store break places based on selected area
  late List<BusInfo> busInfo;

  @override
  void initState() {
    super.initState();
    selectedPathId = widget.trip.pathId;
    selectedArea = 'Area 1'; // Initial selected area
    busInfo = List.from(widget.trip.busInfo); // Create a copy to avoid direct mutation
  }

  void addBus() {
    setState(() {
      busInfo.add(
        BusInfo(busId: 'New', type: 'All', startTime: '00:00', endTime: '00:00'),
      );
    });
  }

  void deleteBus(int index) {
    setState(() {
      busInfo.removeAt(index);
    });
  }

  void changeArea(String newArea) {
    setState(() {
      selectedArea = newArea;
      breakPlaces.clear(); // Clear break places when area changes
    });
  }

  void addBreakPlace() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedBreakPlace = getBreakPlacesForArea(selectedArea).first; // Initialize with the first item

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Break Place'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedBreakPlace,
                    decoration: InputDecoration(labelText: 'Select Break Place'),
                    items: getBreakPlacesForArea(selectedArea)
                        .map((place) => DropdownMenuItem(value: place, child: Text(place)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBreakPlace = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      breakPlaces.add(selectedBreakPlace);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    ).then((result) {
      // After dialog closes, update TripCard with new break places
      setState(() {
        widget.trip.breakPlaces = breakPlaces;
      });
    });
  }

  List<String> getBreakPlacesForArea(String area) {
    // Logic to fetch break places based on selected area
    switch (area) {
      case 'Area 1':
        return ['Break Place A1', 'Break Place A2'];
      case 'Area 2':
        return ['Break Place B1', 'Break Place B2'];
      case 'Area 3':
        return ['Break Place C1', 'Break Place C2'];
      case 'Area 4':
        return ['Break Place D1', 'Break Place D2'];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: selectedPathId,
              decoration: InputDecoration(labelText: 'Path ID'),
              items: ['P1000', 'P1001', 'P1002', 'P1003']
                  .map((pathId) => DropdownMenuItem(value: pathId, child: Text(pathId)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPathId = value!;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: selectedArea,
              decoration: InputDecoration(labelText: 'Area'),
              items: ['Area 1', 'Area 2', 'Area 3', 'Area 4']
                  .map((area) => DropdownMenuItem(value: area, child: Text(area)))
                  .toList(),
              onChanged: (value) {
                changeArea(value!); // Update selected area and clear break places
              },
            ),
            SizedBox(height: 10),
            if (breakPlaces.isEmpty) // Only show "Add Break Place" button if breakPlaces is empty
              ElevatedButton(
                onPressed: addBreakPlace,
                child: Text('Add Break Place'),
              ),
            if (breakPlaces.isNotEmpty)
              Column(
                children: breakPlaces
                    .map((place) => ListTile(
                          title: Text(place),
                        ))
                    .toList(),
              ),
            SizedBox(height: 10),
            Text('Bus Info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...busInfo.asMap().entries.map((entry) {
              int index = entry.key;
              BusInfo info = entry.value;

              return Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bus ID: ${info.busId}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text('Type: ', style: TextStyle(fontSize: 14)),
                          Expanded(
                            child: Column(
                              children: ['All', 'Going'].map((type) {
                                return RadioListTile<String>(
                                  title: Text(type),
                                  value: type,
                                  groupValue: info.type,
                                  onChanged: (value) {
                                    setState(() {
                                      info.type = value!;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: info.startTime,
                              decoration: InputDecoration(labelText: 'Start Time'),
                              onChanged: (value) {
                                setState(() {
                                  info.startTime = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              initialValue: info.endTime,
                              decoration: InputDecoration(labelText: 'End Time'),
                              onChanged: (value) {
                                setState(() {
                                  info.endTime = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => deleteBus(index),
                            child: Text('Delete Bus'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addBus,
              child: Text('Add Bus'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle save action
              },
              child: Text('Save Changes'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

class Trip {
  final String pathId;
  final double price;
  List<String> breakPlaces;
  final List<BusInfo> busInfo;

  Trip({required this.pathId, required this.price, required this.breakPlaces, required this.busInfo});
}

class BusInfo {
  String busId;
  String type;
  String startTime;
  String endTime;

  BusInfo({required this.busId, required this.type, required this.startTime, required this.endTime});
}

