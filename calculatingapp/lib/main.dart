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
      home: const MyHomePage(title: 'Tran Kim Tien Dat'),
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
  double result = 0;
  String opr = '';
  final List<double> items = [];
  final List<double> aList = [];
  final List<double> bList = [];
  final List<String> oprList = [];

  TextEditingController aController = TextEditingController(text: '');
  TextEditingController bController = TextEditingController(text: '');

  void _onPlus() {
    aList.add(double.parse(aController.text));
    bList.add(double.parse(bController.text));
    oprList.add(' + ');

    setState(() {
      result = double.parse(aController.text) + double.parse(bController.text);
      items.add(result);
    });
  }

  void _onMinus() {
    aList.add(double.parse(aController.text));
    bList.add(double.parse(bController.text));
    oprList.add(' - ');
    setState(() {
      result = double.parse(aController.text) - double.parse(bController.text);
      items.add(result);
    });
  }

  void _onMultiply() {
    aList.add(double.parse(aController.text));
    bList.add(double.parse(bController.text));
    oprList.add(' * ');
    setState(() {
      result = double.parse(aController.text) * double.parse(bController.text);
      items.add(result);
    });
  }

  void _onDevide() {
    aList.add(double.parse(aController.text));
    bList.add(double.parse(bController.text));
    oprList.add(' / ');

    setState(() {
      result = double.parse(aController.text) / double.parse(bController.text);
      items.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Two Number',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Flexible(
              flex: 4,
              child: Text(
                'So a: ',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Flexible(
              flex: 9,
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nhap so thu nhat'),
                cursorHeight: 20,
                keyboardType: TextInputType.number,
                controller: aController,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Flexible(
              flex: 4,
              child: Text(
                'So b: ',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Flexible(
              flex: 9,
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Nhap so thu hai'),
                cursorHeight: 20,
                keyboardType: TextInputType.number,
                controller: bController,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  _onPlus();
                },
                child: const Text(
                  '+',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  _onMinus();
                },
                child: const Text(
                  '-',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  _onMultiply();
                },
                child: const Text(
                  '*',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  _onDevide();
                },
                child: const Text(
                  '/',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                color: Colors.green[300],
                shadowColor: Colors.pink,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.filter),
                      title: Text(aList[index].toString() +
                          oprList[index] +
                          bList[index].toString() +
                          ' = ' +
                          items[index].toString()),
                    ),
                  ],
                ),
              );
              // return OutlinedButton(
              //   onPressed: () async {
              //     _navigateDetailScreen(context, index);
              //   },
              //   child: Center(child: Text(items[index].toString())),
              // );
            },
            itemCount: items.length,
            padding: const EdgeInsets.all(8),
          ),
        ),
      ]),
    );
  }
}
