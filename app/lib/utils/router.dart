import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/data/database.dart';
import 'package:bankimoon/data/repo.dart';
import 'package:bankimoon/features/account/screens/add_account.dart';
import 'package:bankimoon/features/splash/screens/splash_screen.dart';
import 'package:bankimoon/features/home/screens/home.dart';
import 'package:bankimoon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late Repository repository;

  AppRouter() {
    repository = Repository(
      connection: DbManager(),
    );
  }

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
            create: (context) => AccountsCubit(repository: repository),
            child: const Home(),
          ),
        );
      case addAccount:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AccountsCubit(repository: repository),
            child: const AddAccount(),
          ),
        );
      default:
        return null;
    }
  }
}
