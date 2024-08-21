import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Country_managment/Add_Country.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Country_managment/All_Country.dart';





class CountryManagementPage extends StatelessWidget {
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
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCountry()),
                );
              },
              child: Text('Create a country'),
            ),
               SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CountryListPage(
                      
                     
                    ),
                  ),
                );
              },
              child: Text('Get All Countries'),
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




