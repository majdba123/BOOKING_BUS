import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/Trip_mangement/Add_Trip.dart';
import 'package:mobile_app/screens/DashBorad_Company/Trip_mangement/All_Trips.dart';


class Trip_managment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Trip Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () {
              Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TripListPage()));
              },
              icon: Icon(Icons.list),
              label: Text('كافة مسارات الرحلات'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blue,
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTripPage()));
              },
              icon: Icon(Icons.add),
              label: Text('اضافة مسار رحلة'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.green,
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}
