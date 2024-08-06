import 'package:flutter/material.dart';

// routes
const splash = '/';
const home = '/home';
const addAccount = '/add-account';
const aboutPage = '/about';
const favouritePage = '/favs';

const bankimoonDescription = """
Bankimoon is an application to help people save account numbers in a convenient place. So that people can stop saving account numbers as phone numbers; hopefully this can reduce errors when sharing account information and when you need it. 

Bankimoon supports different kinds of account numbers that Malawians interact with or use, though we are open to managing more and more.

Bankimoon is a community project by members of GeekQuest.
""";

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
List<String> serviceProviders = [
  'National Bank of Malawi',
  'FDH Bank',
  'Standard Bank',
  'NBS Bank',
  'Eco Bank',
  'Centenary Bank',
  'First Capital Bank',
  'ESCOM',
  'MASM',
  'DSTV',
  'GoTV',
  'Blantyre Water Board',
  'Lilongwe Water Board',
  'Southern Region Water Board',
  'Northern Region Water Board'
];
