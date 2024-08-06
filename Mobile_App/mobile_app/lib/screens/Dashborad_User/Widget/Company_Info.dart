import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/user/Company_Info.dart';
import 'package:provider/provider.dart';
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
        title: Text('Company Info'),
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
                  // First Section: Company Photo
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            // company.user?.profile?.image ??
                            'https://via.placeholder.com/200'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Second Section: Company Info
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company.nameCompany,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'User ID: ${company.userId}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Created At: ${company.createdAt}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        // SizedBox(height: 10),
                        // if (company.user?.address != null) ...[
                        //   Text(
                        //     'Address:',
                        //     style: TextStyle(
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        //   ...company.user!.address!.map((address) => Text(
                        //         address,
                        //         style: TextStyle(
                        //           fontSize: 16,
                        //           color: Colors.grey[600],
                        //         ),
                        //       )),
                        // ],
                      ],
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
}
