import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/company.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/card_for_add_favorites_comapny.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Company_Info.dart';

class AllCompaniesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Companies',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Consumer<TripuserProvider>(
        builder: (context, tripProvider, child) {
          if (tripProvider.compaines.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return _buildCompanyGrid(tripProvider, context);
        },
      ),
    );
  }

  Widget _buildCompanyGrid(
      TripuserProvider tripProvider, BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.8,
      ),
      itemCount: tripProvider.compaines.length,
      itemBuilder: (context, index) {
        final company = tripProvider.compaines[index];
        return _buildCompanyCard(company, context);
      },
    );
  }

  Widget _buildCompanyCard(Company company, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CompanyInfoPage(
              companyId: company
                  .id, // Assuming company.id is the correct field for the ID
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCompanyImage(company),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.nameCompany,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: AppColors.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Bus company',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  _buildRatingStars(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyImage(Company company) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Image.network(
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDvl9ZaLbuWLu6nIaTUvpdcNk2r6US0oJp1w&s', // Replace with company.imageUrl if available
        height: 120.0,
        width: double.infinity,
        fit: BoxFit.fitHeight,
        errorBuilder: (context, error, stackTrace) => Image.network(
          'https://via.placeholder.com/150',
          height: 120.0,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < 4 ? Icons.star : Icons.star_border,
          color: Colors.yellow[700],
          size: 14.0,
        );
      }),
    );
  }
}
