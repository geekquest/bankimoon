import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/data/database.dart';
import 'package:bankimoon/data/repo.dart';
import 'package:bankimoon/presentation/screens/add_account.dart';
import 'package:bankimoon/presentation/screens/favourites.dart';
import 'package:bankimoon/presentation/screens/splash_screen.dart';
import 'package:bankimoon/presentation/screens/home.dart';
import 'package:bankimoon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {

  AppRouter();

  // route generator
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const Splashscreen(),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AccountsCubit(),
            child: const Home(),
          ),
        );
      case favouritePage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AccountsCubit(),
            child: const Favourite(),
          ),
        );
      case addAccount:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AccountsCubit(),
            child: const AddAccount(),
          ),
        );
      default:
        return null;
    }
  }
}
