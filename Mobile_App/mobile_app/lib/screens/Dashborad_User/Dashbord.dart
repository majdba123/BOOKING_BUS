import 'package:flutter/material.dart';



import 'package:mobile_app/widgets/my_text_button.dart';

class DashbordUser extends StatefulWidget {
 
  @override
  State<DashbordUser> createState() => _DashbordUserdState();
}

class _DashbordUserdState extends State<DashbordUser> {

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
      appBar: AppBar(title: Text('واجهة المسستخدم'),centerTitle: true,),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('this is DashbordUserd of the user account '),
      ),
    );
  }
}
