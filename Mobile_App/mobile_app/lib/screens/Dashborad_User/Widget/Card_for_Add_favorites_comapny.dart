import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Rating_Provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Company_Info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class CardfavoriteCompany extends StatefulWidget {
  final String name_of_company;
  final String image_link;
  final String company_id;

  const CardfavoriteCompany({
    required this.name_of_company,
    required this.image_link,
    required this.company_id,
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
      provider.addCompanyToFavorite(widget.company_id);
    } else {
      provider.removeCompanyFromFavorite(widget.company_id);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Adjust sizes based on screen width and height
    double cardWidth = screenWidth *
        0.45; // Adjust width to fit better on various screen sizes
    double cardHeight = screenHeight * 0.23; // Adjust height
    double imageHeight = cardHeight * 0.6; // Image takes 60% of the card height
    double titleFontSize = screenWidth * 0.031; // Title font size
    double subtitleFontSize = screenWidth * 0.035; // Subtitle font size
    double iconSize = screenWidth * 0.05; // Icon size

    // Check if the image URL is valid
    bool isValidUrl = Uri.tryParse(widget.image_link)?.hasAbsolutePath ?? false;
    String imageUrl = isValidUrl
        ? widget.image_link
        : 'https://via.placeholder.com/150'; // Fallback image URL

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CompanyInfoPage(
            companyId: widget.company_id,
          ),
        ),
      ),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02, vertical: screenHeight * 0.01),
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 240, 237, 237),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: imageHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  // BlurHash Placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: BlurHash(
                      hash: 'L5H2EC=PM+yV0g-mq.wG9c010J}I', // Example BlurHash
                      imageFit: BoxFit.cover,
                      decodingHeight: 150,
                      decodingWidth: 150,
                    ),
                  ),
                  // Company Image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/background_mappp.png',
                        image: imageUrl,
                        fit: BoxFit.fill,
                        fadeInDuration: Duration(milliseconds: 500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              widget.name_of_company,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              'Bus company',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: subtitleFontSize,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < 4 ? Icons.star : Icons.star_border,
                      color: Colors.yellow[700],
                      size: iconSize,
                    );
                  }),
                ),
                Spacer(),
                GestureDetector(
                  onTap: _toggleFavorite,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.redAccent : Colors.grey[400],
                    size: iconSize + 6,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
