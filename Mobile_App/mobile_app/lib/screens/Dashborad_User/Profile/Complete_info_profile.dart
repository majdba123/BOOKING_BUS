import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Profile/Profile_User.dart';
import 'package:provider/provider.dart';

class CompleteProfilePage extends StatefulWidget {
  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final _phoneController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _submitProfile(BuildContext context) async {
    if (_formKey.currentState!.validate() && _image != null) {
      var accessToken =
          Provider.of<AuthProvider>(context, listen: false).accessToken;
      var uri = Uri.parse(name_domain_server + 'user/store_profile_info');
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $accessToken'
        ..fields['phone'] = _phoneController.text
        ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

      var response = await request.send();
      print(response.statusCode);
      print(response.reasonPhrase);
      // print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle success
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/mainPageUser', (Route<dynamic> route) => false);
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Complete Profile',
          style: TextStyle(color: Colors.white, fontSize: 22.0),
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: [
            backImage(screenWidth, screenHeight),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Please complete your profile information',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? Icon(Icons.camera_alt, size: 50)
                            : null,
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          // borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 20.0,
                        ),
                        prefixIcon:
                            Icon(Icons.phone, color: AppColors.primaryColor),
                        hintText: 'Enter your phone number',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => _submitProfile(context),
                      child: Text(
                        'Complete Profile',
                        style: TextStyle(color: Colors.white, fontSize: 22.0),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
