import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

// Colors
const kBackgroundColor = Color.fromARGB(255, 179, 175, 193);
const kTextFieldFill = Color.fromARGB(255, 55, 55, 56);
// TextStyles
const kHeadline = TextStyle(
  color: Colors.white,
  fontSize: 34,
  fontWeight: FontWeight.bold,
);

const kBodyText = TextStyle(
  color: Colors.grey,
  fontSize: 15,
);

const kButtonText = TextStyle(
  color: Colors.black87,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
final Color veppoLightGrey = Color(0xFF999999);
final Color veppoGrey = Color(0xFF4C4C4C);
final Color veppoBlue = Color(0xFF1363FF);
const kBodyText2 =
    TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white);

// const name_domain_server = "http://192.168.1.8:8000/api/"; //home
// const name_domain_server = "http://192.168.43.125:8000/api/";  //  4g
const name_domain_server = "http://192.168.0.62:8000/api/";

Route animetedRoutePage(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Widget backImage(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  return Container(
    width: screenWidth,
    height: screenHeight,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          "assets/images/background_mappp.png",
        ),
        fit: BoxFit.cover,
      ),
    ),
  );
}

void showSuccessDialog(BuildContext context, String message) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    animType: AnimType.rightSlide,
    title: 'Success',
    desc: message,
    btnOkOnPress: () {},
  ).show();
}

void showErrorDialog(BuildContext context, String message) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.rightSlide,
    title: 'Error',
    desc: message,
    btnOkOnPress: () {},
  ).show();
}
