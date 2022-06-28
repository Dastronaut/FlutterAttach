import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:s_camera/utils/models/user.dart';

class DevicePage extends StatefulWidget {
  final String phoneNumber;
  const DevicePage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  final CollectionReference docUser =
      FirebaseFirestore.instance.collection('control');
  bool _safety = false;
  bool _buzzer = false;
  bool _lights = false;

  Future<User?> readUser() async {
    print(widget.phoneNumber);
    final docUser = FirebaseFirestore.instance
        .collection('control')
        .doc(widget.phoneNumber);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return User.fromJson(snapshot.data()!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            _buzzer = user!.buzzer;
            _lights = user.light;
            _safety = user.safety;
            return Container(
              constraints: const BoxConstraints.expand(),
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            const Text(
                              "Camera",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 40),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(121, 0, 0, 0),
                              child: Text(
                                "Phát",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.play_circle_outline,
                                //color: Colors.blue,
                              ),
                              iconSize: 30,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        SwitchListTile(
                          title: const Text('Chế độ an toàn'),
                          value: _safety,
                          onChanged: (bool value) async {
                            setState(() {
                              _safety = value;
                            });
                            await docUser
                                .doc(widget.phoneNumber)
                                .update({"safety": value})
                                .then((_) => log('Success'))
                                .catchError((error) => log('Failed: $error'));
                          },
                          secondary: Icon(Icons.health_and_safety_outlined,
                              color: _safety ? Colors.green : Colors.grey),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SwitchListTile(
                          title: const Text('Chuông'),
                          value: _buzzer,
                          onChanged: (bool value) async {
                            setState(() {
                              _buzzer = value;
                            });
                            await docUser
                                .doc(widget.phoneNumber)
                                .update({"buzzer": value})
                                .then((_) => log('Success'))
                                .catchError((error) => log('Failed: $error'));
                          },
                          secondary: Icon(Icons.warning,
                              color: _buzzer ? Colors.red : Colors.grey),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SwitchListTile(
                          title: const Text('Đèn'),
                          value: _lights,
                          onChanged: (bool value) async {
                            setState(() {
                              _lights = value;
                            });
                            await docUser
                                .doc(widget.phoneNumber)
                                .update({"light": value})
                                .then((_) => log('Success'))
                                .catchError((error) => log('Failed: $error'));
                          },
                          secondary: Icon(Icons.lightbulb,
                              color:
                                  _lights ? Colors.yellow[700] : Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
