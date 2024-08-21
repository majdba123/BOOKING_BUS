import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/area.dart';
import 'package:mobile_app/Provider/Admin/Area_Provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:provider/provider.dart';

class CountryListPage extends StatefulWidget {
  @override
  State<CountryListPage> createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<area> filteredCountries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCountries);
    _fetchCountries();
  }

  void _fetchCountries() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final countryProvider = Provider.of<areaProvider>(context, listen: false);
    await countryProvider.fetchareas(authProvider.accessToken);
    setState(() {
      filteredCountries = countryProvider.areas;
      _isLoading = false;
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
    countryProvider.updatearea(authProvider.accessToken, country.id, newName).then((_) {
      _fetchCountries();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Country updated successfully!')),
      );
    });
  }

  void onDeleteCountry(int index) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final countryProvider = Provider.of<areaProvider>(context, listen: false);
    final country = filteredCountries[index];
    countryProvider.deletearea(authProvider.accessToken, country.id).then((_) {
      _fetchCountries();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Country deleted successfully!')),
      );
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
        title: Text('Country Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'All Countries',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Total Countries: ${filteredCountries.length}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredCountries.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
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
                                        final _editController = TextEditingController(
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
                                                Navigator.of(context).pop(_editController.text);
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
                                        content: Text('Are you sure you want to delete ${filteredCountries[index].name}?'),
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
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
