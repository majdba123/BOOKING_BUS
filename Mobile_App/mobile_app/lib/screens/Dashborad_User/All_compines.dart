import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/card_for_add_favorites_comapny.dart';

class AllCompaniesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Companies'),
      ),
      body: Consumer<TripuserProvider>(
        builder: (context, tripProvider, child) {
          if (tripProvider.compaines.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(4.0),
            itemCount: tripProvider.compaines.length,
            itemBuilder: (context, index) {
              final company = tripProvider.compaines[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CardfavoriteCompany(
                  name_of_company: company.nameCompany,
                  image_link:
                      'https://via.placeholder.com/150', // Update with actual image link
                  company_id: company.id,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
