import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final controller = ScrollController();
  int currentTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Trực tiếp",
            style: TextStyle(fontSize: 25, color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: Icon(Icons.splitscreen_outlined),
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.pink],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              )),
        ),
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),

      body: Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.admin_panel_settings),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.purpleAccent,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: "Chụp màn hình",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volume_up_outlined),
            label: "Âm lượng",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pause),
            label: "Tạm dừng",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam_outlined),
            label: "Ghi",
          ),
        ],
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontSize: 15),
      ),
    );
  }
}
