import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:s_camera/utils/models/user.dart';

class TestCase extends StatefulWidget {
  final String phoneNumber;
  const TestCase({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<TestCase> createState() => _TestCaseState();
}

class _TestCaseState extends State<TestCase> {
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

            return user == null
                ? const Center(
                    child: Text('No User'),
                  )
                : Center(
                    child: Text(user.buzzer.toString()),
                  );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
