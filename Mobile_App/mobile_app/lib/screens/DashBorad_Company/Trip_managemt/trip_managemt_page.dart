import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Admin/Break_Area_Provider.dart';
import 'package:mobile_app/Provider/Company/Bus_Provider.dart';
import 'package:mobile_app/Provider/Company/Trip_Provider.dart';
import 'package:mobile_app/Provider/Company/path_provider.dart';
import 'package:mobile_app/screens/DashBorad_Company/Trip_managemt/strore_trip.dart';
import 'package:mobile_app/screens/DashBorad_Company/path_mangement/Add_path.dart';
import 'package:mobile_app/screens/DashBorad_Company/path_mangement/All_paths.dart';
import 'package:provider/provider.dart';


class TripBusmanagment extends StatelessWidget {
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
            // ElevatedButton.icon(
            //   onPressed: () {
            
            //   },
            //   icon: Icon(Icons.list),
            //   label: Text('كافة  الرحلات'),
            //   style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blue,
            //     textStyle: TextStyle(fontSize: 18),
            //   ),
            // ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiProvider(
                  providers: [
                   
                    ChangeNotifierProvider(create: (_) => TripBusProvider()),
                  ],
                  child: TripForm(),
                ),
              ),
            );
              },
              icon: Icon(Icons.add),
              label: Text('اضافة  رحلة'),
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
