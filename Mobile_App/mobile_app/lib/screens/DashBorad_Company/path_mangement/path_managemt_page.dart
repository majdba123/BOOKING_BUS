import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/path_mangement/Add_path.dart';
import 'package:mobile_app/screens/DashBorad_Company/path_mangement/All_paths.dart';


class Path_managment extends StatelessWidget {
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
                    MaterialPageRoute(builder: (context) => PathListPage()));
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
                    MaterialPageRoute(builder: (context) => AddPathPage()));
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
