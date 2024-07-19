import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Trip_by_Path.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Serach_trip_Result.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Colors.dart';

class SearchBusForm extends StatefulWidget {
  @override
  _SearchBusFormState createState() => _SearchBusFormState();
}

class _SearchBusFormState extends State<SearchBusForm> {
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _swapValues() {
    String temp = _fromController.text;
    _fromController.text = _toController.text;
    _toController.text = temp;
    _updateButtonState();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _fromController.text.isNotEmpty && _toController.text.isNotEmpty;
    });
  }

  Future<void> _searchBuses() async {
    final from = _fromController.text;
    final to = _toController.text;

    if (from.isEmpty || to.isEmpty) {
      _showDialog();
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tripProvider = Provider.of<TripuserProvider>(context, listen: false);

    await tripProvider.getTripsByPath(authProvider.accessToken, from, to);
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Both fields must have a value to search.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fromController.addListener(_updateButtonState);
    _toController.addListener(_updateButtonState);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(45.0),
      margin: EdgeInsets.only(left: 15,right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _fromController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.directions_bus),
              hintText: 'From',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          IconButton(
            icon: Icon(Icons.swap_vert),
            onPressed: _swapValues,
          ),
          TextField(
            controller: _toController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.directions_bus_filled),
              hintText: 'To',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          SizedBox(height: 35.0),
          ElevatedButton(
            onPressed: _isButtonEnabled
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusSearchScreen(
                          searchFuture: _searchBuses(),
                        ),
                      ),
                    );
                  }
                : _showDialog,
            child: Text('Search By Path', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
