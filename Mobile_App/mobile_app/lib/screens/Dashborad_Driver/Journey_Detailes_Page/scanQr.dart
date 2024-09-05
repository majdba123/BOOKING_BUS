import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/constants.dart';
import 'package:provider/provider.dart';

Future<String> scanQRCode() async {
  String barcodeScanRes = 'Unknown';
  try {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Scanner overlay color
      'Cancel', // Text for the Cancel button
      true, // Enable flash for scanning
      ScanMode.QR, // Scan mode (QR or barcode)
    );
  } on PlatformException {
    barcodeScanRes = 'Failed to get platform version.';
  }
  return barcodeScanRes;
}

class QRScanScreen extends StatefulWidget {
  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  String scannedCode = 'Unknown';

  Future<void> startScanning() async {
    String scanResult = await scanQRCode();
    if (!mounted) return;

    if (scanResult != '-1' && scanResult != 'Failed to get platform version.') {
      // Call the provider function with the scanned QR code
      var auth = Provider.of<AuthProvider>(context, listen: false);
      var driverProvider = Provider.of<DriverProvider>(context, listen: false);
      await driverProvider.checkReservation(auth.accessToken, scanResult);
      if (driverProvider.isCheckedReservation) {
        _showSuccessDialog(scanResult);
      } else {
        _showErrorDialog(); // Show error dialog
      }
    } else {
      _showErrorDialog(); // Show error if scan failed
    }
  }

  Future<void> _showSuccessDialog(String scanResult) async {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Success',
      desc: 'QR Code scanned successfully: $scanResult',
      btnCancelText: 'Cancel', // Button to cancel the scanning process
      btnCancelOnPress: () {
        Navigator.of(context).pop();
      },
      btnCancelIcon: Icons.cancel,
      btnOkText: 'Scan More',
      btnOkOnPress: () {
        startScanning();
      },
      btnOkIcon: Icons.qr_code_scanner,
      onDismissCallback: (type) {
        debugPrint('Dialog dismissed: $type');
      },
    ).show();
  }

  // Method to show error dialog
  void _showErrorDialog() {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.error,
      showCloseIcon: true,
      title: 'Error',
      desc: 'Failed to scan the QR Code. Please try again.',
      btnOkOnPress: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/StopDetailes', (Route<dynamic> route) => false);
        // Close dialog or stay on same screen
      },
      btnOkIcon: Icons.error,
      onDismissCallback: (type) {
        debugPrint('Dialog dismissed: $type');
      },
    ).show();
  }

  @override
  void initState() {
    super.initState();
    startScanning();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(
      child: backImage(context),
    );
  }
}
