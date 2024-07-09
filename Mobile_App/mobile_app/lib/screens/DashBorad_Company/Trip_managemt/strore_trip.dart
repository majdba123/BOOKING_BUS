import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/BusInfoTrip.dart';
import 'package:mobile_app/Data_Models/Trip.dart';
import 'package:mobile_app/Provider/Admin/Break_Area_Provider.dart';
import 'package:mobile_app/Provider/Company/Bus_Provider.dart';
import 'package:mobile_app/Provider/Company/Path_Provider.dart';
import 'package:mobile_app/Provider/Company/Trip_Provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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

  @override
  void initState() {
    super.initState();
    // Fetch paths and break areas when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<TripBusProvider>(context, listen: false).fetchpaths(authProvider.accessToken);
      Provider.of<TripBusProvider>(context, listen: false).fetchareas(authProvider.accessToken);
    });
    
  }

  void _addBus() {
    setState(() {
      _busInfoList.add(BusInfo(busId: 0, type: 'all', startTime: '', endTime: ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripBusProvider = Provider.of<TripBusProvider>(context);
    final breakAreaProvider = Provider.of<BreakAreaProvider>(context);
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
                items: breakAreaProvider.BreakAreas.map((area) {
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
                DropdownButtonFormField2<int>(
                  decoration: InputDecoration(
                    labelText: 'Select Break Places in Area',
                    border: OutlineInputBorder(),
                  ),
                  items: breakAreaProvider
                      .BreakAreas
                     
                      .map((breakPlace) {
                    return DropdownMenuItem<int>(
                      value: breakPlace.id,
                      child: Text(breakPlace.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      if (value != null && !_selectedBreaksIds.contains(value)) {
                        _selectedBreaksIds.add(value);
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a break place';
                    }
                    return null;
                  },
                ),
              ],
              SizedBox(height: 16),
              ..._busInfoList.asMap().entries.map((entry) {
                int index = entry.key;
                BusInfo busInfo = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField2<int>(
                      decoration: InputDecoration(
                        labelText: 'Select Bus',
                        border: OutlineInputBorder(),
                      ),
                      value: busInfo.busId,
                      items: busProvider.Buss.map((bus) {
                        return DropdownMenuItem<int>(
                          value: bus.id,
                          child: Text(bus.id.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          busInfo.busId = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a bus';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Radio(
                          value: 'all',
                          groupValue: busInfo.type,
                          onChanged: (value) {
                            setState(() {
                              busInfo.type = value!;
                            });
                          },
                        ),
                        Text('All'),
                        Radio(
                          value: 'going',
                          groupValue: busInfo.type,
                          onChanged: (value) {
                            setState(() {
                              busInfo.type = value!;
                            });
                          },
                        ),
                        Text('Going'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Start Time',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                busInfo.startTime = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'End Time',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                busInfo.endTime = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addBus,
                      child: Text('Add Bus'),
                    ),
                    SizedBox(height: 16),
                  ],
                );
              }),
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

                    tripBusProvider.addTrip('', newTrip);
                  }
                },
                child: Text('Add Trip'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
