import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Break_area.dart';
import 'package:mobile_app/Data_Models/BusInfoTrip.dart';
import 'package:mobile_app/Data_Models/Trip.dart';
import 'package:mobile_app/Provider/Admin/Break_Area_Provider.dart';
import 'package:mobile_app/Provider/Company/Bus_Provider.dart';
import 'package:mobile_app/Provider/Company/Path_Provider.dart';
import 'package:mobile_app/Provider/Company/Trip_Provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:mobile_app/screens/DashBorad_Company/Trip_managemt/BusInfoCard.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';

class TripForm extends StatefulWidget {
  @override
  _TripFormState createState() => _TripFormState();
}

class _TripFormState extends State<TripForm> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedPathId;
  int? _selectedAreaId;
  String _price = '';
  List<int> _selectedBreaksIds = [];
  List<BusInfo> _busInfoList = [];
  MultipleSearchController _multipleSearchController = MultipleSearchController();
  List<BreakArea> _filteredBreakAreas = [];

  @override
  void initState() {
    super.initState();
    // Fetch paths, break areas, and buses when the page opens
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<TripBusProvider>(context, listen: false)
          .fetchpaths(authProvider.accessToken);
      Provider.of<TripBusProvider>(context, listen: false)
          .fetchareasbycomapny(authProvider.accessToken);
      Provider.of<BusProvider>(context, listen: false)
          .fetchBuss(authProvider.accessToken);
    });
  }

  void _addBus() {
    final busProvider = Provider.of<BusProvider>(context, listen: false);
    final int firstBusId =
        busProvider.Buss.isNotEmpty ? busProvider.Buss.first.id : 0;
    setState(() {
      _busInfoList.add(
          BusInfo(busId: firstBusId, type: 'all', startTime: '', endTime: ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripBusProvider = Provider.of<TripBusProvider>(context);
    final breakAreaProvider = Provider.of<TripBusProvider>(context);
    final busProvider = Provider.of<BusProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField2<int>(
                decoration: InputDecoration(
                  labelText: 'Select Path',
                  border: OutlineInputBorder(),
                ),
                value: _selectedPathId,
                items: tripBusProvider.paths.map((path) {
                  return DropdownMenuItem<int>(
                    value: path.id,
                    child: Text('${path.from} ➔ ${path.to}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPathId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a path';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _price = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField2<int>(
                decoration: InputDecoration(
                  labelText: 'Select Area',
                  border: OutlineInputBorder(),
                ),
                value: _selectedAreaId,
                items: breakAreaProvider.areas.map((area) {
                  return DropdownMenuItem<int>(
                    value: area.id,
                    child: Text(area.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAreaId = value;
                    _selectedBreaksIds.clear();
                  });

                  // Call fetchplaces function here when an area is selected
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  Provider.of<TripBusProvider>(context, listen: false)
                      .fetchBreakAreas(
                          authProvider.accessToken, _selectedAreaId);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an area';
                  }
                  return null;
                },
              ),
              if (_selectedAreaId != null) ...[
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MultipleSearchSelection<BreakArea>(
                    controller: _multipleSearchController,
                    items: _filteredBreakAreas.isEmpty
                        ? breakAreaProvider.BreakAreas
                        : _filteredBreakAreas,
                    fieldToCheck: (breakArea) => breakArea.name,
                    itemBuilder: (breakArea, index) {
                      return ListTile(
                        title: Text(
                          '${index+1} ) ${breakArea.name}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedBreaksIds.contains(breakArea.id)
                                ? _selectedBreaksIds.remove(breakArea.id)
                                : _selectedBreaksIds.add(breakArea.id);
                          });
                        },
                        trailing: _selectedBreaksIds.contains(breakArea.id)
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : null,
                      );
                    },
                    searchField: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search break areas',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                      style: TextStyle(fontSize: 16),
                      onChanged: (text) {
                        setState(() {
                          _filteredBreakAreas = breakAreaProvider.BreakAreas
                              .where((breakArea) => breakArea.name
                                  .toLowerCase()
                                  .contains(text.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    onPickedChange: (items) {
                      setState(() {
                        _selectedBreaksIds =
                            items.map((breakArea) => breakArea.id).toList();
                        _filteredBreakAreas.clear(); // Hide all items after selection
                      });
                    },
                    showSelectAllButton: false,
                    maximumShowItemsHeight: 200,  pickedItemBuilder: (breakArea) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                breakArea.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _selectedBreaksIds.remove(breakArea.id);
                                
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: 16),
              ..._busInfoList.asMap().entries.map((entry) {
                int index = entry.key;
                BusInfo busInfo = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BusCard(
                      info: busInfo,
                      buses: busProvider.Buss,
                      onChanged: (updatedBusInfo) {
                        setState(() {
                          _busInfoList[index] = updatedBusInfo;
                        });
                      },
                      onDelete: () {
                        setState(() {
                          _busInfoList.removeAt(index);
                        });
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                );
              }).toList(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addBus,
                child: Text('Add Bus'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Trip newTrip = Trip(
                      pathId: _selectedPathId!,
                      price: _price,
                      breaksIds: _selectedBreaksIds,
                      busIds: _busInfoList,
                    );
  // print(newTrip.pathId);
  // print(newTrip.price);
  // print(newTrip.breaksIds);
  // print(newTrip.busIds);
  // for (var element in newTrip.busIds) {
  //   print(element.busId);
  //   print(element.type);
  //   print(element.startTime);
  //   print(element.endTime);
  // }
                    final tripBusProvider =
                        Provider.of<TripBusProvider>(context, listen: false);
                        final authprovider =
                        Provider.of<AuthProvider>(context, listen: false);
                    tripBusProvider.addTrip(authprovider.accessToken, newTrip);
                  }
                },
                child: Text('Add Trip'),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

