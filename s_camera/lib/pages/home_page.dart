import 'package:flutter/material.dart';
import 'package:s_camera/pages/camera_page.dart';
import 'package:s_camera/widgets/my_drawer.dart';

import 'device_page.dart';
import 'library_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final _widgetOptions = [
    const DevicePage(),
    const LibraryPage(),
  ];
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.pink],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              )),
        ),
        foregroundColor: Colors.white,
        elevation: 10,
        title: const Text('TechCAM', style: TextStyle(fontSize: 25)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _onClickCamera,
            icon: const Icon(Icons.splitscreen_outlined),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
      drawer: const MyDrawer(),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets_outlined,
                color: _selectedIndex == 0 ? Colors.white : Colors.black54,
                size: 30),
            label: "Thiết bị",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv_outlined,
                color: _selectedIndex == 1 ? Colors.white : Colors.black54,
                size: 30),
            label: "Thư viện",
          ),
        ],
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontSize: 15),
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }

  void _onClickCamera() {
    Navigator.push(context, MaterialPageRoute(builder: gotoCamera));
  }

  Widget gotoCamera(BuildContext context) {
    return const CameraPage();
  }
}
