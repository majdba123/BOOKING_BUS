import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Company/Assign_bus_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/Company/bus_provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'Driver_Selection_Page.dart';

class BusSelectionPage extends StatefulWidget {
  @override
  _BusSelectionPageState createState() => _BusSelectionPageState();
}

class _BusSelectionPageState extends State<BusSelectionPage> {
  @override
  void initState() {
    super.initState();
    _fetchBuses();
  }

  Future<void> _fetchBuses() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final busProvider = Provider.of<AssingBusProvider>(context, listen: false);
     busProvider.fetchBusByStatus(authProvider.accessToken,'pending');
  }

  void _filterBuses(String query) {
    final busProvider = Provider.of<AssingBusProvider>(context, listen: false);
    // setState(() {
    //   busProvider.Buss = busProvider.Buss
    //       .where((bus) => bus.busNumber.toLowerCase().contains(query.toLowerCase()))
    //       .toList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Bus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Bus by ID',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterBuses,
            ),
            Expanded(
              child: Consumer<AssingBusProvider>(
                builder: (context, busProvider, _) {
                  if (busProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (busProvider.Buss.isEmpty) {
                    return Center(child: Text('No buses found'));
                  }
                  return ListView.builder(
                    itemCount: busProvider.Buss.length,
                    itemBuilder: (context, index) {
                      final bus = busProvider.Buss[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(' ${index+1}) Bus number:${bus.number_bus}'),
                           subtitle: Text('number of passenger : ${bus.number_passenger} /          Status :${bus.status.toUpperCase()} '),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DriverSelectionPage(busId: bus.id.toString()),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
