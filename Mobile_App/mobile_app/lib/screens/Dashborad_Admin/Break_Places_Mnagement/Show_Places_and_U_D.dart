import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
class ShowPlacesPage extends StatefulWidget {
  @override
  _ShowPlacesPageState createState() => _ShowPlacesPageState();
}

class _ShowPlacesPageState extends State<ShowPlacesPage> {
  String? _selectedCountry;
  List<String> countries = [
    'USA', 'Canada', 'Mexico', 'France', 'Germany',
    'Brazil', 'Argentina', 'Chile', 'Peru', 'Colombia',
    // Add more countries here
  ];
  List<String> places = [];
  final TextEditingController _searchController = TextEditingController();

  void _updatePlace(int index, String newName) {
    setState(() {
      places[index] = newName;
    });
  }

  void _deletePlace(int index) {
    setState(() {
      places.removeAt(index);
    });
  }

  void _filterPlaces() {
    // Example logic for filtering places by country
    if (_selectedCountry != null) {
      setState(() {
        places = ['Place 1 in $_selectedCountry', 'Place 2 in $_selectedCountry'];
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            DropdownSearch<String>(enabled: true,
              // showSearchBox: true,
              items: countries,
              // label: "Select Country",
              // hint: "Search and select a country",
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value;
                  _filterPlaces();
                });
              },
              selectedItem: _selectedCountry,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      title: Text(places[index]),
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
                                    text: places[index],
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
                                          Navigator.of(context)
                                              .pop(_editController.text);
                                        },
                                        child: Text('Update'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (newName != null) {
                                _updatePlace(index, newName);
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
                                      'Are you sure you want to delete ${places[index]}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deletePlace(index);
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
            ),
          ],
        ),
      ),
    );
  }
}