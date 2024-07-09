import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/area.dart';
import 'package:mobile_app/Provider/Admin/Area_Provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:provider/provider.dart';
// Import your CountryProvider

class CountryListPage extends StatefulWidget {
  @override
  State<CountryListPage> createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<area> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCountries);
    _fetchCountries();
  }

  void _fetchCountries() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final countryProvider = Provider.of<areaProvider>(context, listen: false);
    countryProvider.fetchareas(authProvider.accessToken).then((_) {
      setState(() {
        filteredCountries = countryProvider.areas;
      });
    });
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      final countryProvider = Provider.of<areaProvider>(context, listen: false);
      filteredCountries = countryProvider.areas.where((country) {
        return country.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void onUpdateCountry(int index, String newName) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final countryProvider = Provider.of<areaProvider>(context, listen: false);
    final country = filteredCountries[index];
    countryProvider
        .updatearea(authProvider.accessToken, index, newName)
        .then((_) {
      _fetchCountries();
    });
  }

  void onDeleteCountry(int index) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final countryProvider = Provider.of<areaProvider>(context, listen: false);
    final country = filteredCountries[index];
    countryProvider.deletearea(authProvider.accessToken, index).then((_) {
      _fetchCountries();
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
                labelText: 'Search by Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Consumer<areaProvider>(
                builder: (context, areaProvider, child) {
                  return ListView.builder(
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          title: Text(filteredCountries[index].name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  final newName = await showDialog<String>(
                                    context: context,
                                    builder: (context) {
                                      final _editController =
                                          TextEditingController(
                                        text: filteredCountries[index].name,
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
                                    onUpdateCountry(index, newName);
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
                                      content: Text(
                                          'Are you sure you want to delete ${filteredCountries[index].name}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            onDeleteCountry(index);
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
