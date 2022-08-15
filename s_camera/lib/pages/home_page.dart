import 'package:flutter/material.dart';
import 'package:s_camera/pages/camera_page.dart';
import 'package:s_camera/widgets/my_drawer.dart';

import 'device_page.dart';
import 'library_page.dart';

class MyHomePage extends StatefulWidget {
  final String phoneNumber;
  const MyHomePage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static String _phoneNumber = '';

  int _selectedIndex = 0;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _phoneNumber = widget.phoneNumber;
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return DevicePage(
          phoneNumber: _phoneNumber,
        );

      case 1:
        return const LibraryPage();

      default:
        return DevicePage(
          phoneNumber: _phoneNumber,
        );
    }
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
      body: getPage(_selectedIndex),
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
