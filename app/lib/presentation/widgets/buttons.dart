import 'package:flutter/material.dart';

import '../../utils/constants.dart';

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
  const SearchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(
        Icons.search,
        color: Colors.white,
      ),
    );
  }
}
