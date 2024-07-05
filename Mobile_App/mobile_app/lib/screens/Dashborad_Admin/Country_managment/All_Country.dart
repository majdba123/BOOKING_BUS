import 'package:flutter/material.dart';

class CountryListPage extends StatefulWidget {
  List<String> countries = ['USA', 'Canada', 'Mexico', 'France', 'Germany'];

  @override
  State<CountryListPage> createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    filteredCountries = widget.countries;
    _searchController.addListener(_filterCountries);
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCountries = widget.countries.where((country) {
        return country.toLowerCase().contains(query);
      }).toList();
    });
  }

  void onUpdateCountry(int index, String newName) {
    setState(() {
      widget.countries[index] = newName;
      _filterCountries();
    });
  }

  void onDeleteCountry(int index) {
    setState(() {
      widget.countries.removeAt(index);
      _filterCountries();
    });
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
        title: Text('All Countries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name or ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCountries.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      title: Text(filteredCountries[index]),
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
                                    text: filteredCountries[index],
                                  );
                                  return AlertDialog(
                                    title: Text('Update Country'),
                                    content: TextField(
                                      controller: _editController,
                                      decoration: InputDecoration(
                                        labelText: 'Country Name',
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
                                onUpdateCountry(
                                  widget.countries.indexOf(filteredCountries[index]),
                                  newName,
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Country'),
                                  content: Text('Are you sure you want to delete ${filteredCountries[index]}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        onDeleteCountry(widget.countries.indexOf(filteredCountries[index]));
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
