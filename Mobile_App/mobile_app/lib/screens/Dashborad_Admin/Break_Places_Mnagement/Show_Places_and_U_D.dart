import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Admin/Break_Area.dart';
import 'package:mobile_app/Provider/Admin/Area_Provider.dart';
import 'package:mobile_app/Provider/Admin/Break_Area_Provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:provider/provider.dart';

class ShowPlacesPage extends StatefulWidget {
  @override
  _ShowPlacesPageState createState() => _ShowPlacesPageState();
}

class _ShowPlacesPageState extends State<ShowPlacesPage> {
  String? _selectedArea;

  @override
  void initState() {
    super.initState();
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

    Provider.of<areaProvider>(context, listen: false).fetchareas(authProvider.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Places'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<areaProvider>(
              builder: (context, areaProvider, child) {
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Area',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedArea,
                  items: areaProvider.areas.map((area) {
                    return DropdownMenuItem<String>(
                      value: area.id.toString(),
                      child: Text(area.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    setState(() {
                      _selectedArea = value;
                    });
                    if (value != null) {
                      Provider.of<BreakAreaProvider>(context, listen: false).fetchBreakAreas(authProvider.accessToken,value);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an area';
                    }
                    return null;
                  },
                );
              },
            ),
            SizedBox(height: 16),
            Consumer<BreakAreaProvider>(
              builder: (context, placeProvider, child) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: placeProvider.BreakAreas.length,
                    itemBuilder: (context, index) {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          title: Text(placeProvider.BreakAreas[index].name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  final newName = await showDialog<String>(
                                    context: context,
                                    builder: (context) {
                                      final _editController = TextEditingController(
                                        text: placeProvider.BreakAreas[index].name,
                                      );
                                      return AlertDialog(
                                        title: Text('Update Place'),
                                        content: TextField(
                                          controller: _editController,
                                          decoration: InputDecoration(
                                            labelText: 'Place Name',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(_editController.text);
                                            },
                                            child: Text('Update'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (newName != null) {
                                    placeProvider.updateBreakArea(authProvider.accessToken,placeProvider.BreakAreas[index].id, newName);
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Place'),
                                      content: Text(
                                          'Are you sure you want to delete ${placeProvider.BreakAreas[index].name}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            placeProvider.deleteBreakArea(authProvider.accessToken,placeProvider.BreakAreas[index].id);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
