import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/inquiry_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/InquiryForm.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/PositionedMessage.dart';

class InquiryFormBystatus extends StatefulWidget {
  @override
  _InquiryFormBystatusState createState() => _InquiryFormBystatusState();
}

class _InquiryFormBystatusState extends State<InquiryFormBystatus> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _statusOptions = ['completed', 'pending', 'replyed'];
  String _selectedStatus = 'pending';

  @override
  void initState() {
    super.initState();
    // Clear inquiries and messages when the page loads
    final provider = Provider.of<InquiryProvider>(context, listen: false);
    provider.clearInquiries();
    provider.clearMessages();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InquiryProvider>(context);
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Fetch Inquiries'),
        backgroundColor: Colors.grey[200],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      items: _statusOptions.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedStatus = newValue;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Select status',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a status';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            provider.fetchInquiries(
                                _selectedStatus, accessToken);
                          }
                        },
                        child: provider.isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                'Fetch Inquiries',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (provider.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          provider.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    if (provider.inquiries.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: provider.inquiries.length,
                        itemBuilder: (context, index) {
                          final inquiry = provider.inquiries[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Email: ${inquiry.email}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          provider
                                              .deleteInquiry(
                                                  inquiry.id, accessToken)
                                              .then((_) {
                                            if (provider.successMessage !=
                                                null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: PositionedMessage(
                                                    message: provider
                                                        .successMessage!,
                                                    icon: Icons.check,
                                                    color: Colors.green,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  elevation: 0,
                                                ),
                                              );
                                              provider.clearMessages();
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Question: ${inquiry.question}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Status: ${inquiry.status}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: inquiry.status == 'completed'
                                          ? Colors.green
                                          : inquiry.status == 'pending'
                                              ? Colors.orange
                                              : Colors.red,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Created At: ${inquiry.createdAt}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Updated At: ${inquiry.updatedAt}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    if (!provider.isLoading && provider.inquiries.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text('No inquiries found. Write one now!'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (provider.successMessage != null)
            PositionedMessage(
              message: provider.successMessage!,
              icon: Icons.check,
              color: Colors.green,
            ),
        ],
      ),
    );
  }
}
