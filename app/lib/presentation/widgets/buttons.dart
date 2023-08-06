import 'package:flutter/material.dart';

import '../../data/cubit/accounts_cubit.dart';
import '../../utils/constants.dart';
import '../screens/account_search_delegate.dart';

class AddAccountButton extends StatelessWidget {
  const AddAccountButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple[800],
      onPressed: () {
        Navigator.pushNamed(context, addAccount);
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(
        Icons.settings,
        color: Colors.white,
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  final AccountsCubit accountsCubit;

  const SearchButton({
    Key? key,
    required this.accountsCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showSearch(
          context: context,
          delegate: AccountSearchDelegate(accountsCubit: accountsCubit),
        );
      },
      icon: const Icon(
        Icons.search,
        color: Colors.white,
      ),
    );
  }
}
