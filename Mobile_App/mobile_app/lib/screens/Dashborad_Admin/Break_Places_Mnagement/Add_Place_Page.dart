import 'package:flutter/material.dart';
class AddPlacePage extends StatefulWidget {
  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _formKey = GlobalKey<FormState>();
  final _placeNameController = TextEditingController();
  String? _selectedCountry;
  List<String> countries = ['USA', 'Canada', 'Mexico', 'France', 'Germany'];

  @override
  void dispose() {
    _placeNameController.dispose();
    super.dispose();
  }

  void _addPlace() {
    if (_formKey.currentState!.validate()) {
      // Handle adding place
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Place Added')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Country',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCountry,
                items: countries.map((country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a country';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _placeNameController,
                decoration: InputDecoration(
                  labelText: 'Place Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the place name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addPlace,
                child: Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}