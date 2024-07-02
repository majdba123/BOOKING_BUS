import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/Driver_managment/Driver.dart';

class UpdateDriverPage extends StatefulWidget {
  final Driver driver;

  UpdateDriverPage({required this.driver});

  @override
  _UpdateDriverPageState createState() => _UpdateDriverPageState();
}

class _UpdateDriverPageState extends State<UpdateDriverPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.driver.name;
    _emailController.text = widget.driver.email;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Driver'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform update logic
                String updatedName = _nameController.text;
                String updatedEmail = _emailController.text;

                // For demo, let's just print a message
                print('Updated driver ${widget.driver.name} with Name: $updatedName, Email: $updatedEmail');

                Navigator.pop(context); // Go back to previous screen
              },
              child: Text('Update Driver'),
            ),
          ],
        ),
      ),
    );
  }
}
