import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'TRAN KIM TIEN DAT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> contacts = [];

  TextEditingController myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextField(
              controller: myController,
              decoration: InputDecoration(
                hintText: 'Enter a name',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      contacts.add(myController.text);
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 15, style: BorderStyle.solid),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    shadowColor: Colors.pink,
                    color: Colors.green,
                    child: ListTile(
                      title: Text(contacts[index]),
                      leading: const Icon(Icons.person),
                    ),
                  );
                },
                itemCount: contacts.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
