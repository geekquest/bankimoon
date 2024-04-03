import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/presentation/screens/add_account.dart';
import 'package:bankimoon/presentation/screens/favourites.dart';
import 'package:bankimoon/presentation/screens/splash_screen.dart';
import 'package:bankimoon/presentation/screens/home.dart';
import 'package:bankimoon/presentation/screens/about.dart';
import 'package:bankimoon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: splash,
      name: "splash",
      builder: (context, state) => const Splashscreen(),
    ),
    GoRoute(
      name: "home",
      path: home,
      builder: (context, state) => BlocProvider(
        create: (context) => AccountsCubit(),
        child: const Home(),
      ),
    ),
    GoRoute(
      name: "favourites",
      path: favouritePage,
      builder: (context, state) => BlocProvider(
        create: (context) => AccountsCubit(),
        child: const Favourite(),
      ),
    ),
    GoRoute(
      name: "add-account",
      path: addAccount,
      builder: (context, state) => BlocProvider(
        create: (context) => AccountsCubit(),
        child: const AddAccount(),
      ),
    ),
    GoRoute(
      name: "about",
      path: aboutPage,
      builder: (context, state) => BlocProvider(
        create: (context) => AccountsCubit(),
        child: const AboutPage(),
      ),
    )
  ],
);

class AppRouter {
  AppRouter();

  // route generator
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const Splashscreen(),
        );
      // case home:
      //   return MaterialPageRoute(
      //     builder: (_) =>
      //   );
      // case favouritePage:
      //   return MaterialPageRoute(
      //     builder: (_) =>
      //   );
      // case addAccount:
      //   return MaterialPageRoute(
      //     builder: (_) =>
      //   );
      // case aboutPage:
      //   return MaterialPageRoute(
      //     builder: (_) =>
      //   );
      default:
        return null;
    }
  }
}
