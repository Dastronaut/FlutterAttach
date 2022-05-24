import 'package:flutter/material.dart';
import 'package:jetpack_composer/pages/book_screen.dart';
import 'package:jetpack_composer/pages/home_screen.dart';
import 'package:jetpack_composer/pages/movie_screen.dart';
import 'package:jetpack_composer/pages/music_screen.dart';
import 'package:jetpack_composer/pages/profile_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final _widgetOptions = [
    const HomeScreen(),
    const MusicScreen(),
    const MovieScreen(),
    const BookScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Tran Kim Tien Dat"),
      ),
      body: _widgetOptions[_currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.white.withOpacity(0.5),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          animationDuration: const Duration(seconds: 1),
          height: 60,
          selectedIndex: _currentIndex,
          onDestinationSelected: (int newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          destinations: const [
            NavigationDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'Home'),
            NavigationDestination(
                selectedIcon: Icon(Icons.music_note),
                icon: Icon(Icons.music_note_outlined),
                label: 'Music'),
            NavigationDestination(
                selectedIcon: Icon(Icons.movie_creation),
                icon: Icon(Icons.movie_creation_outlined),
                label: 'Movies'),
            NavigationDestination(
                selectedIcon: Icon(Icons.menu_book),
                icon: Icon(Icons.menu_book_outlined),
                label: 'Books'),
            NavigationDestination(
                selectedIcon: Icon(Icons.person),
                icon: Icon(Icons.person_outline),
                label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
