import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Address_provider.dart';
import 'package:provider/provider.dart';

class AddAddressDialog extends StatelessWidget {
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;

    return AlertDialog(
      title: Text('Add Address'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _cityController,
            decoration: InputDecoration(labelText: 'City'),
          ),
          TextField(
            controller: _areaController,
            decoration: InputDecoration(labelText: 'Area'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final city = _cityController.text;
            final area = _areaController.text;
            Provider.of<AddressProvider>(context, listen: false)
                .addAddress(city, area, accessToken);
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
