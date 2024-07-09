import 'package:flutter/material.dart';



import 'package:mobile_app/widgets/my_text_button.dart';

class DashbordDriver extends StatefulWidget {
 
  @override
  State<DashbordDriver> createState() => _DashbordDriverdState();
}

class _DashbordDriverdState extends State<DashbordDriver> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Your Name'),
              accountEmail: Text('your.email@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    NetworkImage('https://example.com/your_image.jpg'),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('ادارة مسار الرحلات'),
              onTap: () {
                // Handle Home button tap

                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => Trip_managment()));
              },
            ),
        
            
            // ListTile(
            //   leading: Icon(Icons.info),
            //   title: Text('About'),
            //   onTap: () {
            //     // Handle About button tap
            //     Navigator.pop(context);
            //   },
            // ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('واجهة السائق'),centerTitle: true,),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('this is DashbordDriverd of the driver account '),
      ),
    );
  }
}
