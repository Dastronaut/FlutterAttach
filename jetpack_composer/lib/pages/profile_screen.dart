import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final listProject = [
    'Project 1',
    'Project 2',
    'Project 3',
    'Project 4',
    'Project 5'
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
              width: 4,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/das.jpg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Text(
                'Tran Kim Tien Dat',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text('Intern Flutter Programmer'),
              const SizedBox(
                height: 8,
              ),
              const Text('@Dastronaut'),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Portfolio'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: 4,
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: listProject.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/das.jpg',
                          ),
                        ),
                        title: Text(listProject[index]),
                        subtitle: const Text('A great project'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
