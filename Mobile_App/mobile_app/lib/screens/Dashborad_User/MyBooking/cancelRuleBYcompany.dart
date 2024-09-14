import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/Cancel_Rule.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/widgets/CustomeCirculerProgress.dart';
import 'package:provider/provider.dart';

class CanceltionRule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    var fontSize = screenHeight * 0.015;

    return LayoutBuilder(builder: (context, constraints) {
      return Consumer<TripuserProvider>(builder: (context, provider, child) {
        if (provider.isLoadingRule) {
          return Center(
            child: CustomeProgressIndecator(context),
          );
        }
        if (provider.errorMessage != null) {
          return Center(
            child: Text('Error: ${provider.errorMessage}'),
          );
        }
        List<CancelRule>? rules = provider.cancelRules;
        if (rules == null || rules.isEmpty) {
          return Center(
            child: Text('No Reservation available'),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Table(
            border: TableBorder.all(color: Colors.black26),
            columnWidths: const {
              0: FlexColumnWidth(2),
            },
            children: [
              // Table header
              TableRow(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      'Description',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // Table rows for rules
              ...rules.map((rule) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        rule.description,
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        );
      });
    });
  }
}
