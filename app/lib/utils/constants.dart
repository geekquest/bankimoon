import 'package:flutter/material.dart';

// routes
const splash = '/';
const home = '/home';
const addAccount = '/add-account';

// colors
const btnColor = Color.fromARGB(255, 69, 39, 160);

// styles
const btnStyle = BoxDecoration(
  color: btnColor,
  borderRadius: BorderRadius.all(
    Radius.circular(
      8.6,
    ),
  ),
);

// text styles
const textStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);

TextStyle titleStyles = TextStyle(
  color: Colors.white,
  fontSize: AppSize.ap17,
  fontWeight: FontWeight.bold,
);

// banks array
List<String> banks = [
  'National Bank of Malawi',
  'FDH Bank',
  'Standard Bank',
  'NBS Bank',
  'Eco Bank',
  'My Bucks',
  'First Capital Bank',
  'ESCOM',
  'MASM',
];

class Strings {
  static String title = "Home";
  static String noAcc = "No accounts saved";
  static String yourAcc = "Your Accounts";
}

class AppSize {
  static double ap10 = 10.0;
  static double ap12 = 12.0;
  static double ap15 = 15.0;
  static double ap17 = 17.0;
  static double ap20 = 20.0;
}
