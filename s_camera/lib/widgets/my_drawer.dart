import 'package:flutter/material.dart';
import 'package:s_camera/widgets/drawer_ListTile.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(
              height: 200,
              child: CircleAvatar(
                radius: 110,
                backgroundColor: Colors.black12,
                child: CircleAvatar(
                  radius: 90,
                  backgroundImage: AssetImage(
                    'assets/images/das.jpg',
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            const DrawerListTile(
                icon: Icon(Icons.person_outline), title: 'Hồ sơ của tôi'),
            const DrawerListTile(
                icon: Icon(Icons.photo_library_outlined),
                title: 'Album của tôi'),
            const DrawerListTile(
                icon: Icon(Icons.settings_outlined), title: 'Cài đặt chung'),
            const DrawerListTile(
                icon: Icon(Icons.people_outline), title: 'Gia đình & khách'),
            const DrawerListTile(
                icon: Icon(Icons.layers_outlined),
                title: 'Tích hợp thông minh'),
            const DrawerListTile(
                icon: Icon(Icons.info_outline), title: 'Thông tin thêm'),
          ],
        ),
      ),
    );
  }
}
