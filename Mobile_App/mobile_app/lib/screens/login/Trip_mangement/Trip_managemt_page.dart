import 'package:flutter/material.dart';
import 'package:mobile_app/screens/login/Trip_mangement/Add_Trip.dart';

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
                // Handle Get All Trips action
              },
              icon: Icon(Icons.list),
              label: Text('كافة مسارات الرحلات'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
                primary: Colors.blue,
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
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
                primary: Colors.green,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Handle Update Trip action
              },
              icon: Icon(Icons.update),
              label: Text('تعديل مسار رحلة'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
                primary: Colors.orange,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Handle Delete Trip action
              },
              icon: Icon(Icons.delete),
              label: Text('حذف مسار رحلة'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
                primary: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
