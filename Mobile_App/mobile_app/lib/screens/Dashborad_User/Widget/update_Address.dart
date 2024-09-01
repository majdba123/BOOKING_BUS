import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Address_model.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Address_provider.dart';
import 'package:mobile_app/colors.dart';
import 'package:mobile_app/screens/WidgetApp/Textfiled.dart';
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
      backgroundColor: AppColors.primaryColor,
      title: Text(
        'Update Address',
        style: TextStyle(color: Colors.white, fontSize: 22.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          textFiledinput(_cityController, 'Enter the name of the City', 'City'),
          SizedBox(
            height: 20.0,
          ),
          textFiledinput(_areaController, 'Enter the name of the Area', 'Area'),
        ],
      ),
      actions: [
        TextButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: () {
            final city = _cityController.text;
            final area = _areaController.text;
            Provider.of<AddressProvider>(context, listen: false)
                .updateAddress(address.id, city, area, accessToken);
            Navigator.of(context).pop();
          },
          child: Text(
            'Update',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ),
      ],
    );
  }
}
