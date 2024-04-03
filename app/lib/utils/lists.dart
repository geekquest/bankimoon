import 'package:bankimoon/data/cubit/accounts_cubit.dart';
import 'package:bankimoon/presentation/screens/about.dart';
import 'package:bankimoon/presentation/screens/favourites.dart';
import 'package:bankimoon/presentation/screens/landing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final List screens = [
  BlocProvider(
    create: (context) => AccountsCubit(),
    child: const LandingPage(),
  ),
  BlocProvider(
    create: (context) => AccountsCubit(),
    child: const Favourite(),
  ),
  BlocProvider(
    create: (context) => AccountsCubit(),
    child: const AboutPage(),
  ),
];
