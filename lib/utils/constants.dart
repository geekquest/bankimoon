import 'package:flutter/material.dart';

// routes
const createpassword = '/';
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

const titleStyles = TextStyle(
  color: Colors.white,
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
