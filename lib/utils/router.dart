import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/presentation/screens/add_account.dart';
import 'package:bankimoon/presentation/screens/edit_account.dart';
import 'package:bankimoon/presentation/screens/splash_screen.dart';
import 'package:bankimoon/presentation/screens/home.dart';
import 'package:bankimoon/presentation/screens/about.dart';
import 'package:bankimoon/utils/constants.dart';
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
      name: "add-account",
      path: addAccount,
      builder: (context, state) => BlocProvider(
        create: (context) => AccountsCubit(),
        child: const AddAccount(),
      ),
    ),
    GoRoute(
        name: "edit-account",
        path: editAccount,
        builder: (context, state) {
          var accountID = state.pathParameters["id"]!;
          return BlocProvider(
              create: (context) => AccountsCubit(),
              child: EditAccountPage(accountId: int.parse(accountID)));
        }),
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
