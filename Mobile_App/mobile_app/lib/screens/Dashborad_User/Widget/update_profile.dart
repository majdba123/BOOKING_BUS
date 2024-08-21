import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/Provider/user/Profile_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/user_info_profile.dart';
import 'package:provider/provider.dart';

import 'package:mobile_app/Provider/Auth_provider.dart';
import 'dart:io';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _updateProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var accessToken =
          Provider.of<AuthProvider>(context, listen: false).accessToken;
      await Provider.of<updateProfileProvider>(context, listen: false)
          .updateProfile(
        _image,
        _phoneController.text,
        _nameController.text,
        _emailController.text,
        accessToken,
      );

      var profileProvider =
          Provider.of<updateProfileProvider>(context, listen: false);
      if (profileProvider.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false).userInfo;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Your Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.camera_alt, size: 50)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                // initialValue: userInfoProvider?.profile['phone'],
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                // initialValue: userInfoProvider!.name,
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return null; // Name is optional
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                // initialValue: userInfoProvider!.email,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _updateProfile(context),
                child: Text('Update Profile'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Full-width button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
