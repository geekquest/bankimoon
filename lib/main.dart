import 'package:bankimoon/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter().generateRoute,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: const Color.fromARGB(255, 87, 42, 163),
          fontFamily: GoogleFonts.lato().fontFamily,
        ),
      ),
    );
  });
}
