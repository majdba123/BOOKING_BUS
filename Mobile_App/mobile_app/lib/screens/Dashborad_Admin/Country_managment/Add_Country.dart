import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Country_managment/All_Country.dart';



class AddCountry extends StatefulWidget {
  @override
  _AddCountryState createState() => _AddCountryState();
}

class _AddCountryState extends State<AddCountry> {
  final TextEditingController _countryController = TextEditingController();
  List<String> countries = [];

  @override
  void dispose() {
    _countryController.dispose();
    super.dispose();
  }

  void _addCountry() {
    if (_countryController.text.isNotEmpty) {
      setState(() {
        countries.add(_countryController.text);
      });
      _countryController.clear();
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
          children: [
            TextFormField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Country Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addCountry,
              child: Text('Add Country'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}
