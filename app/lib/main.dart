import 'package:bankimoon/data/isar_repo.dart';
import 'package:bankimoon/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IsarRepo.instance.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter().generateRoute,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.lato().fontFamily,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 15, 91, 254),
          ),
        ),
      ),

    );
  });
}
