import 'package:flutter/material.dart';
import 'package:s_camera/pages/login_page.dart';

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
            ListTile(
              leading: const Icon(Icons.person_outline),
              onTap: () {},
              title: const Text('Hồ sơ của tôi'),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              onTap: () {},
              title: const Text('Cài đặt chung'),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              onTap: () {},
              title: const Text('Gia đình & khách'),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.layers_outlined),
              onTap: () {},
              title: const Text('Tích hợp thông minh'),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              title: const Text('Đăng xuất'),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
