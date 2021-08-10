import 'package:demo2/screens/cart_screen.dart';
import 'package:demo2/screens/feed_screen.dart';
import 'package:demo2/screens/home_screen.dart';
import 'package:demo2/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  List _pages = [
    HomePage(),
    FeedsScreen(),
    CartScreen(),
    UserScreen(),
  ];

  int _selectedIndex = 0;

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          child: BottomNavigationBar(
            onTap: _selectedPage,
            backgroundColor: Theme.of(context).primaryColor,
            unselectedItemColor: Theme.of(context).primaryColor,
            selectedItemColor: Colors.purple,
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), tooltip: 'Home', label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.rss_feed), tooltip: 'Feeds', label: 'Feeds'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), tooltip: 'Search', label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), tooltip: 'User', label: 'User'),
            ],
          ),
        ),
      ),
    );
  }
}
