import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/Provider/user/private_Trip_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Colors.dart';

class PrivateTripPage extends StatefulWidget {
  @override
  _PrivateTripPageState createState() => _PrivateTripPageState();
}

class _PrivateTripPageState extends State<PrivateTripPage> {
  final _formKey = GlobalKey<FormState>();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'Private Trip',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 32),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(26),
                    margin: EdgeInsets.fromLTRB(26, 26, 26, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/logo_bus.jpg', // Change to your bus logo
                          ),
                        ),
                        SizedBox(height: 14),
                        Center(
                          child: Text(
                            'Private Trip',
                            style: TextStyle(
                              fontSize: 32,
                            ),
                          ),
                        ),
                        SizedBox(height: 28),
                        TextFormField(
                          controller: _fromController,
                          decoration: InputDecoration(
                            labelText: 'From',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a starting point';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _toController,
                          decoration: InputDecoration(
                            labelText: 'To',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a destination';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            _pickDate(context);
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: InputDecoration(
                                labelText: 'Date (dd/MM/yyyy)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            _pickStartTime(context);
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _startTimeController,
                              decoration: InputDecoration(
                                labelText: 'Start Time (HH:mm)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a start time';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 28),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                    0xFF002F40), // Set the background color
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.0), // Set vertical padding
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final from = _fromController.text;
                                  final to = _toController.text;
                                  final date = _dateController.text;
                                  final startTime = _startTimeController.text;
                                  final accessToken = Provider.of<AuthProvider>(
                                          context,
                                          listen: false)
                                      .accessToken;

                                  try {
                                    await Provider.of<PrivateTripuserProvider>(
                                            context,
                                            listen: false)
                                        .storePrivateTrip(from, to, date,
                                            startTime, accessToken);
                                    final message =
                                        Provider.of<PrivateTripuserProvider>(
                                                context,
                                                listen: false)
                                            .message;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(message ??
                                              'Private trip created successfully')),
                                    );
                                    Navigator.pop(context);
                                  } catch (error) {
                                    print(error);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to create private trip')),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Create Trip',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _pickDate(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        setState(() {
          _dateController.text = DateFormat('dd/MM/yyyy').format(date);
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  void _pickStartTime(BuildContext context) {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (time) {
        setState(() {
          _startTimeController.text = DateFormat('HH:mm').format(time);
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    super.dispose();
  }
}
