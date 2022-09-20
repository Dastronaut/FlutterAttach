import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DevicePage extends StatefulWidget {
  final String phoneNumber;
  const DevicePage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  final DatabaseReference controlRef = FirebaseDatabase.instance.ref('Control');
  bool _buzzer = false;
  bool _lights = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: controlRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.snapshot.value;
            _buzzer = (data as Map)['Buzzer'];
            _lights = (data)['Light'];
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
                                  TextStyle(color: Colors.black, fontSize: 34),
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
                            await controlRef.update({
                              "Buzzer": value,
                            });
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
                            await controlRef.update({
                              "Light": value,
                            });
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
