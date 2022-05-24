import 'package:flutter/material.dart';
import 'item_arguments.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ItemArguments;
    TextEditingController myController =
        TextEditingController(text: args.value.toString());
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Screen'),
        ),
        body: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: myController,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context,
                    ItemArguments(args.id, int.parse(myController.text)));
              },
              child: const Text('OK'),
            ),
          ],
        ));
  }
}
