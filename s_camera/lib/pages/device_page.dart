import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({Key? key}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  final CollectionReference _mode =
      FirebaseFirestore.instance.collection('control');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _mode.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData & streamSnapshot.data!.docs.isNotEmpty) {
            final DocumentSnapshot documentSnapshot =
                streamSnapshot.data!.docs[0];
            bool _buzzer = documentSnapshot['buzzer'];
            bool _lights = documentSnapshot['light'];
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
                          title: const Text('Alert'),
                          value: _buzzer,
                          onChanged: (bool value) async {
                            setState(() {
                              _buzzer = value;
                            });
                            await _mode
                                .doc(documentSnapshot.id)
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
                          title: const Text('Lights'),
                          value: _lights,
                          onChanged: (bool value) async {
                            setState(() {
                              _lights = value;
                            });
                            await _mode
                                .doc(documentSnapshot.id)
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
