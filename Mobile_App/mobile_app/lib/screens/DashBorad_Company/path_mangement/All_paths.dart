import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/path.dart';
import 'package:mobile_app/Provider/Company/path_provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:provider/provider.dart';

class PathListPage extends StatefulWidget {
  @override
  _PathListPageState createState() => _PathListPageState();
}

class _PathListPageState extends State<PathListPage> {


  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<PathProvider>(context, listen: false).fetchpaths(authProvider.accessToken);
  }

  void _showUpdateDialog(BuildContext context, Path path, int index) {
    final _fromController = TextEditingController(text: path.from);
    final _toController = TextEditingController(text: path.to);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update path'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _fromController,
              decoration: InputDecoration(labelText: 'From'),
            ),
            TextField(
              controller: _toController,
              decoration: InputDecoration(labelText: 'To'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final pathProvider = Provider.of<PathProvider>(context, listen: false);
               final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await pathProvider.updatepath(authProvider.accessToken, path.id, _fromController.text, _toController.text);
             print(pathProvider.paths[1].to);
              Navigator.of(context).pop();
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete path'),
        content: Text('Are you sure you want to delete this path?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final pathProvider = Provider.of<PathProvider>(context, listen: false);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await pathProvider.deletepath(authProvider.accessToken, id);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pathProvider = Provider.of<PathProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('All paths'),
      ),
      body: pathProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: pathProvider.paths.length,
                itemBuilder: (context, index) {
                  final path = pathProvider.paths[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${path.from} ➔ ${path.to}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Created: ${path.createdAt}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Updated: ${path.updatedAt}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      _showUpdateDialog(context, path, index);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteDialog(context, path.id, index);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
