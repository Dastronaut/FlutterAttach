import 'package:flutter/material.dart';

import 'bottom_navigation_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation Bar',
      theme: ThemeData(
        primaryColor: Colors.yellow[600],
      ),
      home: BottomBarScreen(),
    );
  }
}
