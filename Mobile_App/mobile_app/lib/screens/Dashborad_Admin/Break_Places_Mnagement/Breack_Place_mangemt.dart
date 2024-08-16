import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Break_Places_Mnagement/Add_Place_Page.dart';
import 'package:mobile_app/screens/Dashborad_Admin/Break_Places_Mnagement/Show_Places_and_U_D.dart';




class BreakPlaceManagament extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Break Places Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPlacePage()),
                );
              },
              child: Text('Add Place'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowPlacesPage()),
                );
              },
              child: Text('Show All Places'),
            ),
          ],
        ),
      ),
    );
  }
}



