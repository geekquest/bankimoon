import 'package:bankimoon/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push("/add-account");
        },
        label: const Text("New "),
        icon: const Icon(
          Icons.add,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color.fromARGB(255, 144, 168, 236),
        selectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        backgroundColor: const Color.fromARGB(255, 15, 91, 254),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
              ),
              label: "Favorites"),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info,
            ),
            label: "About",
          )
        ],
      ),
    );
  }
}
