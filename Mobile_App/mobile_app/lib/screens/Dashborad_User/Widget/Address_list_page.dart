import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Address_provider.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Add_new_address.dart';

import 'package:mobile_app/screens/Dashborad_User/Widget/update_Address.dart';

import 'package:provider/provider.dart';

class AddressListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;

    // Fetch addresses when the widget is built
    Provider.of<AddressProvider>(context, listen: false)
        .fetchAddresses(accessToken);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'My Addresses',
          style: TextStyle(color: Colors.white, fontSize: 22.0),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddAddressDialog(),
              );
            },
          ),
        ],
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          if (addressProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (addressProvider.addresses.isEmpty) {
            return Center(
              child: Text('No addresses found.'),
            );
          } else {
            return ListView.builder(
              itemCount: addressProvider.addresses.length,
              itemBuilder: (context, index) {
                final address = addressProvider.addresses[index];
                return Stack(
                  children: [
                    backImage(context),
                    Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      elevation: 5,
                      child: ListTile(
                        leading: Icon(Icons.location_on, color: Colors.blue),
                        title: Text('City : ${address.city}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        subtitle: Text('Area : ${address.area}'),
                        trailing: IconButton(
                          icon: Icon(Icons.edit, color: Colors.grey),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  UpdateAddressDialog(address: address),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
