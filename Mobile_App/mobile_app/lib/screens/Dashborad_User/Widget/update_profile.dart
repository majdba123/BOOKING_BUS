import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/user/Profile_provider.dart';
import 'package:mobile_app/Provider/user/user_info_profile.dart';
import 'package:mobile_app/colors.dart';
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

  @override
  void initState() {
    super.initState();
    var userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false).userInfo;
    _phoneController.text = userInfoProvider?.phoneNumber ?? '';
    _nameController.text = userInfoProvider?.name ?? '';
    _emailController.text = userInfoProvider?.email ?? '';
  }

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

      // Call the updateProfile method and wait for it to complete
      await Provider.of<updateProfileProvider>(context, listen: false)
          .updateProfile(
        _image,
        _phoneController.text,
        _nameController.text,
        _emailController.text,
        accessToken,
      )
          .then((_) {
        var profileProvider =
            Provider.of<updateProfileProvider>(context, listen: false);

        if (profileProvider.errorMessage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.of(context).pop(); // Navigate back to the previous page
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(profileProvider.errorMessage!)),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false).userInfo;
    return Consumer<updateProfileProvider>(
      builder: (context, profileProvider, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: AppColors.primaryColor,
            title:
                Text('Update Profile', style: TextStyle(color: Colors.white)),
            elevation: 4.0,
          ),
          body: Stack(
            children: [
               backImage(context),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : userInfoProvider?.profile_image != null
                                      ? NetworkImage(
                                          userInfoProvider!.profile_image!)
                                      : null,
                              child: _image == null &&
                                      userInfoProvider?.profile_image == null
                                  ? Icon(Icons.camera_alt,
                                      size: 50, color: Colors.grey[600])
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.edit,
                                    size: 20, color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(_phoneController, 'Phone',
                          'Please enter your phone number'),
                      SizedBox(height: 16),
                      _buildTextFormField(_nameController, 'Name', null),
                      SizedBox(height: 16),
                      _buildTextFormField(
                          _emailController, 'Email', 'Please enter your email'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _updateProfile(context),
                        child: Text('Update Profile',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (profileProvider.isLoading)
                Container(
                  color: Colors.black
                      .withOpacity(0.3), // Semi-transparent background
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label,
      String? validationMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      validator: (value) {
        if (validationMessage != null && (value == null || value.isEmpty)) {
          return validationMessage;
        }
        return null;
      },
    );
  }
}
