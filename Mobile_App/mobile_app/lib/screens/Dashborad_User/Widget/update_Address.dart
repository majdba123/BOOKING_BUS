import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Address_model.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Address_provider.dart';
import 'package:provider/provider.dart';

class UpdateAddressDialog extends StatelessWidget {
  final Address address;

  final _cityController = TextEditingController();
  final _areaController = TextEditingController();

  UpdateAddressDialog({required this.address}) {
    _cityController.text = address.city;
    _areaController.text = address.area;
  }

  @override
  Widget build(BuildContext context) {
    var accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;

    return AlertDialog(
      title: Text('Update Address'),
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
                .updateAddress(address.id, city, area, accessToken);
            Navigator.of(context).pop();
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}
