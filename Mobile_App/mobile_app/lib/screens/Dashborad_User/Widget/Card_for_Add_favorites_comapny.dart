import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Rating_Provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class CardfavoriteCompany extends StatefulWidget {
  final String name_of_company;
  final String image_link;
  final int company_id; // Add company ID

  const CardfavoriteCompany({
    required this.name_of_company,
    required this.image_link,
    required this.company_id, // Add company ID
  });

  @override
  _CardfavoriteCompanyState createState() => _CardfavoriteCompanyState();
}

class _CardfavoriteCompanyState extends State<CardfavoriteCompany> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool('favorite_${widget.company_id}') ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final provider = Provider.of<RatingUserProvider>(context, listen: false);
    provider.setAccessToken(
        Provider.of<AuthProvider>(context, listen: false).accessToken);
    setState(() {
      isFavorite = !isFavorite;
    });

    await prefs.setBool('favorite_${widget.company_id}', isFavorite);
    if (isFavorite) {
      print('add to fav: ');
      provider.addCompanyToFavorite(widget.company_id);
    }

    if (!isFavorite) {
      print('canel add to fav: ');
      provider.removeCompanyFromFavorite(widget.company_id);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize =
        screenWidth * 0.030; // Adjust the scale factor as needed

    return Container(
      width: 200, // Adjusted width for better proportion
      margin: EdgeInsets.only(right: 12.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Ensures the column takes minimum vertical space
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 30.0,
            child: Center(
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://t3.ftcdn.net/jpg/02/51/59/46/360_F_251594672_c7xertPrElSFJ5eTd6V0CmQE1CyGC6Ke.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.0),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name_of_company,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Bus company', // Placeholder for additional info
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: titleFontSize * 0.8,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 4
                              ? Icons.star
                              : Icons
                                  .star_border, // Assuming a 4-star rating as placeholder
                          color: Colors.yellow[700],
                          size: titleFontSize ,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
