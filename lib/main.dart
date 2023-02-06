import 'package:bankimoon/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter().generateRoute,
      ),
    );
  });
}

// https://medium.flutterdevs.com/sql-database-storage-using-sqlite-in-flutter-6e2fdcc8cfb7
