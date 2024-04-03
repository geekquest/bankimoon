import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/constants.dart';
import '../screens/home.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromARGB(255, 15, 91, 254),
      shape: const CircularNotchedRectangle(),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                // ignore: prefer_const_constructors
                icon: Icon(
                  Icons.home,
                  color: Colors.white, // Set the icon color to white
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Home as String);
                },
              ),
              // ignore: prefer_const_constructors
              Text(
                'Home',
                // ignore: prefer_const_constructors
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                // ignore: prefer_const_constructors
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white, // Set the icon color to white
                ),
                onPressed: () {
                  Navigator.pushNamed(context, favouritePage);
                },
              ),
              // ignore: prefer_const_constructors
              const Text(
                'Favorites',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white, // Set the icon color to white
                ),
                onPressed: () {
                  context.push("/add-account");
                  Navigator.pushNamed(context, addAccount);
                },
              ),
              const Text(
                'Add Account',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.account_circle,
                  color: Colors.white, // Set the icon color to white
                ),
                onPressed: () {},
              ),
              const Text(
                'My Accounts',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.info,
                  color: Colors.white, // Set the icon color to white
                ),
                onPressed: () {
                  Navigator.pushNamed(context, aboutPage);
                },
              ),
              const Text(
                'About',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
