import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/user/Update_password_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';

class UpdatePasswordPage extends StatefulWidget {
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmationController = TextEditingController();
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _newPasswordConfirmationVisible = false;

  void _updatePassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var accessToken =
          Provider.of<AuthProvider>(context, listen: false).accessToken;

      // Trigger the password update
      await Provider.of<PasswordProvider>(context, listen: false)
          .updatePassword(
        _currentPasswordController.text,
        _newPasswordController.text,
        _newPasswordConfirmationController.text,
        accessToken,
      );

      var passwordProvider =
          Provider.of<PasswordProvider>(context, listen: false);
      if (passwordProvider.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Update Password',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<PasswordProvider>(
        builder: (context, passwordProvider, child) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Change Your Password',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _currentPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _currentPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _currentPasswordVisible =
                                    !_currentPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_currentPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _newPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _newPasswordVisible = !_newPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_newPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your new password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _newPasswordConfirmationController,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _newPasswordConfirmationVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _newPasswordConfirmationVisible =
                                    !_newPasswordConfirmationVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_newPasswordConfirmationVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your new password';
                          } else if (value != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      if (passwordProvider.errorMessage != null)
                        Text(
                          passwordProvider.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _updatePassword(context),
                        child: Text(
                          'Update Password',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          minimumSize:
                              Size(double.infinity, 50), // Full-width button
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (passwordProvider.isLoading)
                Container(
                  color: Colors.black54, // Semi-transparent background
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
