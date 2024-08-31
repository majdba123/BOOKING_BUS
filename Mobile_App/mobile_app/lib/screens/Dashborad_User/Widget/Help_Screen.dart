import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/user/inquiry_by_status.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Profile/Profile_User.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/InquiryForm.dart';

class HelpDeskScreen extends StatefulWidget {
  @override
  _HelpDeskScreenState createState() => _HelpDeskScreenState();
}

class _HelpDeskScreenState extends State<HelpDeskScreen> {
  final List<Map<String, String>> _faqs = [
    {
      "question": "What is the Bus Reservation System?",
      "answer":
          "The Bus Reservation System allows you to book and manage bus tickets online easily."
    },
    {
      "question": "How to book a ticket?",
      "answer":
          "To book a ticket, search for your desired route, select a bus, choose seats, and make a payment."
    },
    {
      "question": "How to cancel a booking?",
      "answer":
          "You can cancel your booking from the 'My Bookings' section by selecting the booking you want to cancel and following the instructions."
    },
    {
      "question": "How to check the status of a booking?",
      "answer":
          "You can check the status of your booking in the 'My Bookings' section, where all your active and past bookings are listed."
    },
    {
      "question": "How to check the status of a booking?",
      "answer":
          "You can check the status of your booking in the 'My Bookings' section, where all your active and past bookings are listed."
    },
    {
      "question": "How to check the status of a booking?",
      "answer":
          "You can check the status of your booking in the 'My Bookings' section, where all your active and past bookings are listed."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help ',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
              result: ModalRoute.withName('/ProfilePage'),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Stack(
        children: [
          backImage(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We're here to help you with anything and everything on Bus Reservation System",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Our system ensures you can book and manage your bus tickets with ease. If you have any questions or concerns, check our frequently asked questions below or send us a message.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                Text(
                  'FAQ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _faqs.length + 2,
                    itemBuilder: (context, index) {
                      if (index < _faqs.length) {
                        return FAQItem(
                          question: _faqs[index]['question']!,
                          answer: _faqs[index]['answer']!,
                        );
                      } else if (index == _faqs.length) {
                        return Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InquiryForm()),
                              );
                            },
                            child: Text('Send a message'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              textStyle: TextStyle(fontSize: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InquiryFormBystatus()),
                                );
                              },
                              child: Text('Show My Inquiries by Status'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                textStyle: TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            answer,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}
