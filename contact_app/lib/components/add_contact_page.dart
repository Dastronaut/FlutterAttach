import 'package:contact_app/components/contac_argument.dart';
import 'package:flutter/material.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key? key}) : super(key: key);

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  String dropdownValue = 'Mobile';
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: '');
    TextEditingController phoneController = TextEditingController(text: '');
    TextEditingController mailController = TextEditingController(text: '');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a contact'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                color: Colors.blue,
                child: IconButton(
                  onPressed: () {
                    print("OK");
                  },
                  icon: const Icon(
                    Icons.person,
                    size: 120,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                controller: nameController,
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(50.0, 20.0, 20.0, 20.0),
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                controller: nameController,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: 'Phone number',
                        border: OutlineInputBorder(),
                      ),
                      controller: phoneController,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Mobile', 'Phone']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: 'Email (Optional)',
                  border: OutlineInputBorder(),
                ),
                controller: mailController,
              ),
              const SizedBox(
                height: 8.0,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    Contact(
                        name: nameController.text,
                        numphone: phoneController.text,
                        mail: mailController.text),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ));
  }
}
