import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Admin/Area_Provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Country_managment/All_Country.dart';

class AddCountry extends StatefulWidget {
  @override
  _AddCountryState createState() => _AddCountryState();
}

class _AddCountryState extends State<AddCountry> {
  final TextEditingController _countryController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _countryController.dispose();
    super.dispose();
  }

  void _addCountry() async {
    if (_countryController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final AreaProvider = Provider.of<areaProvider>(context, listen: false);

      try {
        await AreaProvider.addarea(authProvider.accessToken, _countryController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Country added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _countryController.clear();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add country. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Country name cannot be empty.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
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
              'Add a New Country',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Country Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _addCountry,
                    child: Text('Add Country'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CountryListPage()),
                );
              },
              child: Text('View All Countries'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
