import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Rating_Provider.dart';
import 'package:provider/provider.dart';

class RatingUi extends StatefulWidget {
  @override
  _RatingUiState createState() => _RatingUiState();
}

class _RatingUiState extends State<RatingUi> {
  late Future<void> _fetchCompaniesFuture;

  @override
  void initState() {
    super.initState();
    final userProvider =
        Provider.of<RatingUserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    userProvider.setAccessToken(authProvider.accessToken);
    _fetchCompaniesFuture = userProvider.fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<RatingUserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Company To FAV'),
      ),
      body: FutureBuilder(
        future: _fetchCompaniesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading companies'));
          }
          return ListView.builder(
            itemCount: userProvider.companies.length,
            itemBuilder: (context, index) {
              final company = userProvider.companies[index];
              return ListTile(
                // title: Text(company.user!.name),
                trailing: IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () async {
                    String message =
                        await userProvider.addCompanyToFavorite(company.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
