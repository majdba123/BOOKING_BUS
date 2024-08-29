import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/user/Company_Info.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/colors.dart';

class CompanyInfoPage extends StatefulWidget {
  final int companyId;

  CompanyInfoPage({required this.companyId});

  @override
  _CompanyInfoPageState createState() => _CompanyInfoPageState();
}

class _CompanyInfoPageState extends State<CompanyInfoPage> {
  late String _accessToken;

  @override
  void initState() {
    super.initState();
    _accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
    _fetchData();
  }

  void _fetchData() {
    Provider.of<CompanyInfoProvider>(context, listen: false)
        .fetchCompanyInfo(widget.companyId, _accessToken);
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
        title: Text(
          'Company Info',
          style: TextStyle(color: Colors.white, fontSize: 22.0),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Consumer<CompanyInfoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          } else if (provider.company == null) {
            return Center(child: Text('No company information found.'));
          } else {
            final company = provider.company!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Image with CachedNetworkImage
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://t3.ftcdn.net/jpg/02/51/59/46/360_F_251594672_c7xertPrElSFJ5eTd6V0CmQE1CyGC6Ke.jpg',
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, size: 50),
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0),
                          ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Company Info Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              company.nameCompany,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.person, color: Colors.grey[600]),
                                SizedBox(width: 8),
                                Text(
                                  'User ID: ${company.userId}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Divider(),
                            _buildAboutSection(),
                            Divider(),
                            _buildContactSection(),
                            Divider(),
                            _buildSocialMediaSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Us',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'We are a leading transportation company, providing top-notch services to our customers for over 20 years. Our mission is to make your travel experience comfortable and convenient.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                '+1 234 567 890',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.email, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                'info@company.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                '123 Main St, City, Country',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSocialMediaIcon(Icons.facebook, Colors.blue),
          _buildSocialMediaIcon(Icons.facebook, Colors.lightBlue),
          _buildSocialMediaIcon(Icons.facebook, Colors.blue[700]!),
          _buildSocialMediaIcon(Icons.facebook, Colors.pink),
        ],
      ),
    );
  }

  Widget _buildSocialMediaIcon(IconData iconData, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle social media icon tap
      },
      child: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(iconData, color: color),
      ),
    );
  }
}
