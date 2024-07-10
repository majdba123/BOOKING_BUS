import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Admin/Area_Provider.dart';
import 'package:mobile_app/Provider/Admin/Break_Area_Provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:provider/provider.dart';

class AddPlacePage extends StatefulWidget {
  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _formKey = GlobalKey<FormState>();
  final _placeNameController = TextEditingController();
  String? _selectedArea;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<areaProvider>(context, listen: false).fetchareas(authProvider.accessToken);
  }

  @override
  void dispose() {
    _placeNameController.dispose();
    super.dispose();
  }

  void _addPlace() {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final placeProvider = Provider.of<BreakAreaProvider>(context, listen: false);
      placeProvider.addBreakArea(authProvider.accessToken, _selectedArea!, _placeNameController.text).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Place added successfully!')),
        );
        _placeNameController.clear();
        setState(() {
          _selectedArea = null;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add place: $error')),
        );
      });
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
                      setState(() {
                        _selectedArea = value;
                      });
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
