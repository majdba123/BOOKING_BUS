import 'package:flutter/material.dart';

class DeleteBusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Bus'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Are you sure you want to delete this bus?',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Perform delete operation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bus Deleted')),
                  );
                  Navigator.pop(context);
                },
                child: Text('Delete Bus'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
